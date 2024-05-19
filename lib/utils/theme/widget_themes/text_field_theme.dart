import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class MyTextFormFieldTheme {
  MyTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    fillColor: Colors.grey.shade100,
    filled: true,
    labelStyle:
        const TextStyle(fontSize: MySizes.fontSizeMd, color: Colors.black54),
    hintStyle:
        const TextStyle(fontSize: MySizes.fontSizeSm, color: Colors.black26),
    border: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.black12,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: MyColors.primary,
        width: 2.0,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.black12, // Default border color
      ),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
