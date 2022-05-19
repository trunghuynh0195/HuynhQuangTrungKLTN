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
    //thêm user vào danh sách những user đã điểm danh
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
    debugPrint('Khoảng cách giữa bạn và sự kiện là: $distanceIsMeter');
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
      //Lấy khoảng cách giữa user và event
      await getTheDistance(event);
      //Kiểm tra sự kiện có đang diễn ra hay không
      if (startTimeEvent.isBefore(DateTime.now()) &&
          endTimeEvent.isAfter(DateTime.now())) {
        //kiểm tra khoảng cách giữa người dùng với sự kiện có đạt tiêu chuẩn không
        if (distanceIsMeter < kLimitDistanceBetweenUserAndEvent) {
          // Kiểm tra user đã điểm danh chưa
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
                    title: 'Điểm danh thành công!',
                  );
                });
            debugPrint('Điểm danh thành công!');
          } else {
            debugPrint('Bạn đã điểm danh sự kiện này rồi!');
            showDialogLoading(context, false);
            showDialog(
                context: context,
                builder: (_) {
                  return const DialogError(
                    title: 'Bạn đã điểm danh sự kiện này rồi!',
                  );
                });
          }
        } else {
          debugPrint(
              'Khoảng cách giữa bạn với sự kiện phải đạt tối thiểu 100 mét!');
          showDialogLoading(context, false);
          showDialog(
              context: context,
              builder: (_) {
                return const DialogError(
                  title:
                      'Khoảng cách giữa bạn với sự kiện không được quá 100 mét!',
                );
              });
        }
      } else {
        debugPrint('Sự kiện không diên ra!');
        showDialogLoading(context, false);
        showDialog(
            context: context,
            builder: (_) {
              return const DialogError(
                title: 'Sự kiện không diễn ra!',
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
        debugPrint('Không thể nhận diện. Vui lòng thử lại!');
        showDialog(
            context: context,
            builder: (_) {
              return const DialogError(
                title: 'Điểm danh không thành công!',
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
