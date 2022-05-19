import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String? hintText;
  final void Function(String)? onChanged;
  final int? maxLines;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final EdgeInsetsGeometry? contentPadding;
  final bool readOnly;
  final Widget? suffixIcon;
  final void Function()? onTap;
  final double? height;
  final double borderRadius;
  final Color? focusColor;
  final FocusNode? focusNode;
  final bool obscureText;
  final void Function(String)? onSubmitted;
  const TextFieldWidget({
    Key? key,
    this.hintText,
    this.onChanged,
    this.prefixIcon,
    this.keyboardType,
    this.controller,
    this.maxLines = 1,
    this.contentPadding,
    this.readOnly = false,
    this.onTap,
    this.height,
    this.suffixIcon,
    this.borderRadius = 15,
    this.focusColor,
    this.focusNode,
    this.onSubmitted,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        maxLines: maxLines,
        readOnly: readOnly,
        obscureText: obscureText,
        focusNode: focusNode,
        onSubmitted: onSubmitted,
        textAlign: TextAlign.start,
        style: const TextStyle(fontSize: 14),
        onTap: onTap,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          suffixIcon: suffixIcon,
          hintText: hintText,
          contentPadding: contentPadding,
          focusColor: focusColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }
}
