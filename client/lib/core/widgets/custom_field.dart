import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isObscureText;
  final bool readOnly;
  final VoidCallback? onTap;
  const CustomField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.readOnly = false,
      this.onTap,
      this.isObscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
        readOnly: readOnly,
        obscureText: isObscureText,
        controller: controller,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$hintText cannot be empty.';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hintText,
        ));
  }
}
