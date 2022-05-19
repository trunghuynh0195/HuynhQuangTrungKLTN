import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showAttendanceDialog(BuildContext context, String text) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(
          text,
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      );
    },
  );
}

void showCameraPermissionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          "Camera's permission",
          textAlign: TextAlign.center,
        ),
        content: const Text(
          "You did not allow Attendance to access your camera. You must go to Setting to allow Attendance to access your camera.",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      );
    },
  );
}
