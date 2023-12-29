import 'package:aplicacion_manga_admin_panel/services/theme.dart';
import 'package:flutter/material.dart';

class LogInForm extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const LogInForm(
      {key,
      required this.controller,
      required this.hintText,
      required this.obscureText});

  //bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            labelStyle: const TextStyle(
              color: kTextFieldColor,
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor),
            ),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500])),
        //hintStyle: TextStyle(color: Colors.white)),
      ),
    );
  }
}
