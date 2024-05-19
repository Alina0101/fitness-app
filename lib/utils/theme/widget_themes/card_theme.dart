import 'package:flutter/material.dart';

class MyCardTheme {
  MyCardTheme._();

  static final myCardTheme = CardTheme(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Изменен горизонтальный отступ
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.white
  );
}
