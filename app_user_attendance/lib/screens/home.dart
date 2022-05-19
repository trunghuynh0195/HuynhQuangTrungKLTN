import 'package:app_user_attendance/bloc/attendance_event_bloc.dart';
import 'package:app_user_attendance/models/user.dart';
import 'package:app_user_attendance/screens/attendance_event.dart';
import 'package:app_user_attendance/screens/user_profile.dart';
import 'package:app_user_attendance/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class Home extends StatefulWidget {
  final User? user;
  const Home({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userID = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
  int _currentIndex = 0;
  List<Widget> pageView = [];
  @override
  void initState() {
    super.initState();
    pageView = [
      const AttendanceEvent(),
      UserProfile(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFE5E5E5),
          body: pageView[_currentIndex],
          extendBody: true,
          bottomNavigationBar: _buildBottomNavigationBar(),
          floatingActionButton: FloatingActionButton(
            onPressed: () =>
                AttendanceEventBloC().scanQrCode(constraints, context),
            backgroundColor: AppColor.primaryDarkBlue,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                'assets/images/qr_scan.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ),
      );
    });
  }

  _buildBottomNavigationBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      child: BottomAppBar(
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
      ),
    );
  }
}
