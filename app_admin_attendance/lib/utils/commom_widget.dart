import 'package:flutter/material.dart';

Future<bool> showConfirmDialog(
  BuildContext context, {
  String? title,
  String? message,
  String actionText = 'Có',
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: title != null ? Text(title) : null,
      content: Text('$message'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Không'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(actionText),
        ),
      ],
    ),
  ).then((value) => value ?? false);
}

ScaffoldFeatureController<Widget, dynamic> showSnackBar(
    BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}
