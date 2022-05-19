import 'package:app_admin_attendance/bloc/admin_profile_bloc.dart';
import 'package:app_admin_attendance/models/user.dart';
import 'package:app_admin_attendance/screens/change_password.dart';
import 'package:app_admin_attendance/screens/login.dart';
import 'package:app_admin_attendance/utils/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  AdminProfileBloC bloc = AdminProfileBloC();
  TextStyle textStyleInformation = const TextStyle(
    color: AppColor.primaryDarkBlue,
    fontSize: 17,
  );
  @override
  void initState() {
    super.initState();
    bloc.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 238, 243),
      body: StreamBuilder<User>(
        stream: bloc.getUserStream,
        builder: (context, snapshot) {
          User user = snapshot.data ?? User();
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImage(user),
                  _buildInformation(user),
                  _buildChangePassword(),
                  _buildLogout(),
                ],
              ),
            ),
          );
        },
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

  Widget _buildInformation(User user) {
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
          _buildText('Email: ', '${user.email}'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: _buildText('Phone number: ', '${user.phoneNumber}'),
          ),
          _buildText('Date of Birth: ', '${user.dateOfBirth}'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: _buildText('Address: ', '${user.address}'),
          ),
          const SizedBox(
            height: 30,
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

  Widget _buildImage(User user) {
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
                    '${user.fullName}',
                    style: const TextStyle(
                        color: AppColor.primaryDarkBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    '${user.mcb}',
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
