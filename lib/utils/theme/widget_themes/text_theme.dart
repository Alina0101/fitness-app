import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class MyTextTheme {
  MyTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
        fontSize: 40.0, fontWeight: FontWeight.w500, color: MyColors.textWhite),
    headlineMedium: const TextStyle().copyWith(
        fontSize: 25.0, fontWeight: FontWeight.w500, color: MyColors.textWhite),
    headlineSmall: const TextStyle().copyWith(
        fontSize: 25.0,
        fontWeight: FontWeight.w600,
        color: MyColors.textSecondary),
    titleLarge: const TextStyle().copyWith(
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        color: MyColors.textPrimary),
    titleMedium: const TextStyle().copyWith(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        color: MyColors.textSecondary),
    titleSmall: const TextStyle().copyWith(
        fontSize: 13.0, fontWeight: FontWeight.w400, color: MyColors.textWhite),
    bodyLarge: const TextStyle().copyWith(
        fontSize: 15.0,
        fontWeight: FontWeight.w500,
        color: MyColors.textSecondary),
    bodyMedium: const TextStyle().copyWith(
        fontSize: 15.0,
        fontWeight: FontWeight.normal,
        color: MyColors.textSecondary),
    bodySmall: const TextStyle().copyWith(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: MyColors.dark.withOpacity(0.5)),
    labelLarge: const TextStyle().copyWith(
        fontSize: 12.0, fontWeight: FontWeight.normal, color: MyColors.light),
    labelMedium: const TextStyle().copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 17,
      color: Colors.black,
    ),
    labelSmall: const TextStyle().copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: Colors.grey.shade700,),
  );
}
