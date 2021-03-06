import 'package:app_user_attendance/models/event.dart';
import 'package:app_user_attendance/models/user.dart';
import 'package:app_user_attendance/screens/home.dart';
import 'package:app_user_attendance/widgets/commom_widget.dart';
import 'package:app_user_attendance/widgets/dialog_error.dart';
import 'package:app_user_attendance/widgets/dialog_success.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

//100 meter
const kLimitDistanceBetweenUserAndEvent = 100;

class AttendanceEventBloC {
  final _listEvent = BehaviorSubject<List<Event>>();
  Stream<List<Event>> get listEventStream => _listEvent.stream;

  List<Map<String, dynamic>> dataEventsResponseFromFireCloud = [];
  CollectionReference data = FirebaseFirestore.instance.collection('Events');

  final _userFromFireBase = auth.FirebaseAuth.instance.currentUser;
  double distanceIsMeter = 0;
  Position? _currentUserPosition;
  User user = User();

  Future<void> getListEvents() async {
    await FirebaseFirestore.instance
        .collection('Events')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        dataEventsResponseFromFireCloud.add(doc.data() as Map<String, dynamic>);
      }
    });
    List<Event> list = dataEventsResponseFromFireCloud
        .cast<Map<String, dynamic>>()
        .map<Event>((e) => Event.fromJson(e))
        .toList();
    _listEvent.add(list);
  }

  Future<User> getUser(String userID) async {
    // User user = User();
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .get()
        .then((value) {
      user = User.fromJson(value.data() ?? {});
    });
    return user;
  }

  User userFromFirebase(auth.User? user) {
    if (user == null) {
      return User();
    }
    return User(uid: user.uid, email: user.email);
  }

  Future<void> attendanceEvent(
      {required User user, required Event event}) async {
    List<User> listUser = event.listUser ?? [];
    //th??m user v??o danh s??ch nh???ng user ???? ??i???m danh
    listUser.add(user);
    List<Map<String, dynamic>> list =
        listUser.map((User user) => user.toJson()).toList();
    data
        .doc('${event.id}')
        .update({'list_user': list})
        .then((value) => debugPrint('Is Attendance'))
        .catchError((onError) {
          debugPrint(onError);
        });
  }

  Future<Position?> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return _currentUserPosition = await Geolocator.getCurrentPosition();
  }

  Future getTheDistance(Event event) async {
    await determinePosition();
    distanceIsMeter = Geolocator.distanceBetween(
      _currentUserPosition?.latitude ?? 0,
      _currentUserPosition?.longitude ?? 0,
      event.latLocationEvent ?? 0,
      event.lngLocationEvent ?? 0,
    );
    debugPrint('Kho???ng c??ch gi???a b???n v?? s??? ki???n l??: $distanceIsMeter');
  }

  _handlerBeforeAttendance(String eventID, BuildContext context) async {
    showDialogLoading(context, true);
    debugPrint(eventID);
    await data.doc(eventID).get().then((DocumentSnapshot querySnapshot) async {
      var data = Map<String, dynamic>.from(querySnapshot.data() as Map);
      Event event = Event.fromJson(data);
      var startTimeEvent =
          DateTime.fromMillisecondsSinceEpoch(event.startDate ?? 0);
      var endTimeEvent =
          DateTime.fromMillisecondsSinceEpoch(event.endDate ?? 0);
      var listUser = (event.listUser ?? []).map((user) => user.uid).toList();
      //L???y kho???ng c??ch gi???a user v?? event
      await getTheDistance(event);
      //Ki???m tra s??? ki???n c?? ??ang di???n ra hay kh??ng
      if (startTimeEvent.isBefore(DateTime.now()) &&
          endTimeEvent.isAfter(DateTime.now())) {
        //ki???m tra kho???ng c??ch gi???a ng?????i d??ng v???i s??? ki???n c?? ?????t ti??u chu???n kh??ng
        if (distanceIsMeter < kLimitDistanceBetweenUserAndEvent) {
          // Ki???m tra user ???? ??i???m danh ch??a
          if (!listUser.contains(_userFromFireBase?.uid)) {
            attendanceEvent(
                event: event, user: userFromFirebase(_userFromFireBase));
            await getUser(_userFromFireBase?.uid ?? '');
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => Home(user: user)),
                (route) => false);
            showDialog(
                context: context,
                builder: (_) {
                  return const DialogSuccess(
                    title: '??i???m danh th??nh c??ng!',
                  );
                });
            debugPrint('??i???m danh th??nh c??ng!');
          } else {
            debugPrint('B???n ???? ??i???m danh s??? ki???n n??y r???i!');
            showDialogLoading(context, false);
            showDialog(
                context: context,
                builder: (_) {
                  return const DialogError(
                    title: 'B???n ???? ??i???m danh s??? ki???n n??y r???i!',
                  );
                });
          }
        } else {
          debugPrint(
              'Kho???ng c??ch gi???a b???n v???i s??? ki???n ph???i ?????t t???i thi???u 100 m??t!');
          showDialogLoading(context, false);
          showDialog(
              context: context,
              builder: (_) {
                return const DialogError(
                  title:
                      'Kho???ng c??ch gi???a b???n v???i s??? ki???n kh??ng ???????c qu?? 100 m??t!',
                );
              });
        }
      } else {
        debugPrint('S??? ki???n kh??ng di??n ra!');
        showDialogLoading(context, false);
        showDialog(
            context: context,
            builder: (_) {
              return const DialogError(
                title: 'S??? ki???n kh??ng di???n ra!',
              );
            });
      }
    }).catchError((onError) {
      showDialogLoading(context, false);
      debugPrint(onError);
    });
  }

  void scanQrCode(BoxConstraints constraints, BuildContext context) async {
    var cameraPermissionStatus = await Permission.camera.request();
    if (cameraPermissionStatus.isGranted) {
      var result = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      if (result.isNotEmpty) {
        _handlerBeforeAttendance(result, context);
      } else {
        debugPrint('Kh??ng th??? nh???n di???n. Vui l??ng th??? l???i!');
        showDialog(
            context: context,
            builder: (_) {
              return const DialogError(
                title: '??i???m danh kh??ng th??nh c??ng!',
              );
            });
      }
    } else {
      if (cameraPermissionStatus == PermissionStatus.granted) {
        scanQrCode(constraints, context);
      } else {
        showCameraPermissionDialog(context);
      }
    }
  }

  showDialogLoading(BuildContext context, bool isLoading) {
    if (isLoading) {
      showDialog(
          context: context,
          builder: (_) {
            return Container(
              color: Colors.white.withOpacity(0.2),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          });
    } else {
      Navigator.pop(context);
    }
  }

  void dispose() {
    _listEvent.close();
  }
}
