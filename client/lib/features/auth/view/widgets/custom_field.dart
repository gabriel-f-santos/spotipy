import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  const CustomField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.isObscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
