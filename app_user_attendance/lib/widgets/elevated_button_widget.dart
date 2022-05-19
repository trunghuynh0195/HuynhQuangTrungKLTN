import 'package:flutter/material.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final String? title;
  final Color? textColor;
  final Color? backgroundColor;
  final double borderRadiusCircular;
  final void Function()? onPressed;
  const ElevatedButtonWidget({
    Key? key,
    this.title,
    this.textColor,
    this.backgroundColor,
    this.onPressed,
    this.borderRadiusCircular = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusCircular),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Text(
            title ?? '',
            style: TextStyle(color: textColor, fontSize: 16),
          ),
        ));
  }
}
