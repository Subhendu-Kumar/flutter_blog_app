import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final bool isHide;
  final String hintText;
  final TextEditingController controller;

  const AuthField({
    super.key,
    this.isHide = false,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your $hintText";
        }
        return null;
      },
      decoration: InputDecoration(hintText: hintText),
      obscureText: isHide,
    );
  }
}
