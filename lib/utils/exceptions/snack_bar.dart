import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_auth_exceptions.dart';

class SnackBarService {
  static void showError(BuildContext context, FirebaseAuthException e) {
    String errorMessage = FirebaseAuthExceptions(e.code).message;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          errorMessage,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating, // Плавающее поведение
        margin: EdgeInsets.only(top: 16, left: 8, right: 8), // Отступ сверху
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating, // Плавающее поведение
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height-200, left: 8, right: 8), // Отступ сверху
      ),
    );
  }
}
