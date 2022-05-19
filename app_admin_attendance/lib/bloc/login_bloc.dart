import 'dart:async';
import 'package:app_admin_attendance/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginBloC {
  final _showPass = StreamController<bool>.broadcast();
  Stream<bool> get showPassStream => _showPass.stream;

  set changeStatusShowPass(bool value) => _showPass.sink.add(value);

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

  void dispose() {
    _showPass.close();
  }
}
