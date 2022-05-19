import 'package:app_admin_attendance/screens/login.dart';
import 'package:app_admin_attendance/utils/app_color.dart';
import 'package:app_admin_attendance/utils/widgets/text_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var user = auth.FirebaseAuth.instance.currentUser;
  final TextEditingController _newPass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            'Change Password',
            style: TextStyle(
                fontSize: 30,
                color: AppColor.primaryDarkBlue,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 50,
          ),
          TextFieldWidget(
            controller: _newPass,
            hintText: 'New password',
            borderRadius: 30,
            contentPadding:
                const EdgeInsets.only(left: 20, top: 18, bottom: 18),
          ),
          const SizedBox(
            height: 25,
          ),
          TextFieldWidget(
            controller: _confirmPass,
            hintText: 'Confirm password',
            borderRadius: 30,
            contentPadding:
                const EdgeInsets.only(left: 20, top: 18, bottom: 18),
          ),
          const SizedBox(
            height: 50,
          ),
          MaterialButton(
            onPressed: () {
              if (_newPass.text.isNotEmpty &&
                  _confirmPass.text.isNotEmpty &&
                  _confirmPass.text == _newPass.text) {
                changePassword();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Thông tin không chính xác!')));
              }
            },
            color: const Color.fromARGB(255, 99, 135, 211),
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.transparent)),
            child: const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'Save changes',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  changePassword() async {
    try {
      await user?.updatePassword(_newPass.text);
      auth.FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đổi mật khẩu thành công!')));
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => const Login()), (route) => false);
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$error')));
    }
  }
}
