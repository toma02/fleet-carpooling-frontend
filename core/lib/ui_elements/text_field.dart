import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors' as my_defined_colors;

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final RegExp? regex;
  final bool isPassword;
  final bool onlyDigits;
  final TextInputType keyboardType;
  final Color backgroundColor;

  const MyTextField({
    Key? key,
    required this.controller,
    this.regex,
    this.isPassword = false,
    this.onlyDigits = false,
    this.keyboardType = TextInputType.text,
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        inputFormatters:
            onlyDigits ? [FilteringTextInputFormatter.digitsOnly] : [],
        decoration: InputDecoration(
          filled: true,
          fillColor: backgroundColor,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: const BorderSide(
              color: my_defined_colors.AppColors.buttonColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: const BorderSide(
              color: my_defined_colors.AppColors.buttonColor,
            ),
          ),
        ),
      ),
    );
  }
}
