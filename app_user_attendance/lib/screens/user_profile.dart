import 'package:app_user_attendance/models/user.dart';
import 'package:app_user_attendance/screens/change_password.dart';
import 'package:app_user_attendance/screens/login.dart';
import 'package:app_user_attendance/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class UserProfile extends StatefulWidget {
  final User? user;
  const UserProfile({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String userID = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
  TextStyle textStyleInformation = const TextStyle(
    color: AppColor.primaryDarkBlue,
    fontSize: 17,
  );
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 238, 243),
      body: userView(),
    );
  }

  Widget userView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildImage(),
          _buildInformation(),
          _buildChangePassword(),
          _buildLogout(),
        ]),
      ),
    );
  }

  Widget _buildChangePassword() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const ChangePassword(),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(166, 187, 189, 192),
                  borderRadius: BorderRadius.circular(6)),
              child: const Icon(
                Icons.lock_clock,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            const Text(
              'Change your password',
              style: TextStyle(
                  color: AppColor.primaryDarkBlue, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInformation() {
    return Padding(
      padding: const EdgeInsets.only(top: 47, bottom: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông tin liên hệ',
            style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF667085)),
          ),
          const SizedBox(
            height: 28,
          ),
          _buildText('Email: ', '${widget.user?.email}'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: _buildText('Phone number: ', '${widget.user?.phoneNumber}'),
          ),
          _buildText('Date of Birth: ', '${widget.user?.dateOfBirth}'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: _buildText('Majoring: ', '${widget.user?.majoring}'),
          ),
          _buildText('Course: ', '${widget.user?.course}'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: _buildText('Address: ', '${widget.user?.address}'),
          ),
        ],
      ),
    );
  }

  Widget _buildText(String title, String information) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: title,
            style: const TextStyle(
              color: Color(0xFF667085),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          TextSpan(
            text: information,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
  }

  showMyAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Log Out?"),
            content: const Text("Are you sure want to log out?"),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.grey),
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: AppColor.primaryDarkBlue),
                  child: const Text("Log out"),
                  onPressed: () {
                    auth.FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const Login()),
                        (route) => false);
                  }),
            ],
          );
        });
  }

  Widget _buildLogout() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        showMyAlertDialog(context);
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(166, 187, 189, 192),
                        borderRadius: BorderRadius.circular(6)),
                    child: const Icon(Icons.logout)),
                const SizedBox(
                  width: 15,
                ),
                const Text(
                  'Log Out',
                  style: TextStyle(
                      color: AppColor.primaryDarkBlue,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_outlined,
            size: 20,
          )
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 50,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColor.primaryDarkBlue,
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.user?.fullName}',
                    style: const TextStyle(
                        color: AppColor.primaryDarkBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    '${widget.user?.msv}',
                    style: const TextStyle(
                      color: AppColor.primaryDarkBlue,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
          ),
        ],
      ),
    );
  }
}
