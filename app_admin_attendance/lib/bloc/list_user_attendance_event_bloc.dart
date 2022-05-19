import 'dart:async';
import 'package:app_admin_attendance/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class ListUserAttendanceEventBloC {
  final _listUser = BehaviorSubject<List<User>>.seeded([]);
  Stream<List<User>> get listUserStream => _listUser.stream;

  List<User> listUserFromFirebase = [];
  Future<User> getUser(String userID) async {
    User user = User();
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .get()
        .then((value) {
      user = User.fromJson(value.data() ?? {});
    });
    return user;
  }

  Future<void> getListUser(List<User> listUser) async {
    for (var user in listUser) {
      await getUser('${user.uid}').then(
        (user) => listUserFromFirebase.add(user),
      );
    }
    _listUser.add(listUserFromFirebase);
  }

  void dispose() {
    _listUser.close();
  }
}
