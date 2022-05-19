import 'package:app_admin_attendance/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'package:rxdart/rxdart.dart';

class AdminProfileBloC {
  final _user = BehaviorSubject<User>();
  Stream<User> get getUserStream => _user.stream;
  var userID = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
  Future<User> getUser() async {
    User user = User();
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .get()
        .then((value) {
      user = User.fromJson(value.data() ?? {});
    });
    _user.add(user);
    return user;
  }

  void dispose() {}
}
