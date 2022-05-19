import 'package:app_admin_attendance/models/user.dart';
import 'package:app_admin_attendance/screens/admin_profile.dart';
import 'package:app_admin_attendance/screens/manager_event.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final user = auth.FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> listMap = [];
  int _currentIndex = 0;
  List<Widget> pageView = [];

  @override
  void initState() {
    super.initState();
    pageView = [
      const ManagerEvent(),
      const AdminProfile(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffFAFBFF),
        body: pageView[_currentIndex],
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  _buildBottomNavigationBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _currentIndex = 0;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 30, top: 15, bottom: 15),
              child: Image.asset(
                _currentIndex == 0
                    ? 'assets/images/home_ac.png'
                    : 'assets/images/home.png',
                fit: BoxFit.cover,
                height: 24,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _currentIndex = 1;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 30, top: 15, bottom: 15),
              child: Image.asset(
                _currentIndex == 1
                    ? 'assets/images/user_ac.png'
                    : 'assets/images/user.png',
                fit: BoxFit.cover,
                height: 24,
              ),
            ),
          )
        ]),
      ),
    );
  }
}
