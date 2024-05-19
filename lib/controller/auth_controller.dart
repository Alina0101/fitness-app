import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/controller/workout_progress_controller.dart';
import 'package:flutter/material.dart';
import '../model/models/fitness_user.dart';
import '../utils/exceptions/firebase_auth_exceptions.dart';
import 'firestore_services.dart';
import 'fitness_user_controller.dart';

class AuthController {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static bool get isUserEmailVerified => auth.currentUser!.emailVerified;

  static void _showErrorDialog(String errorMessage, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('ОШИБКА'),
          content: Text(
            errorMessage,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('ОК'),
            ),
          ],
        );
      },
    );
  }

  static Future<void> registerUser(
      String email, String password, String name, BuildContext context) async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      FitnessUser user = FitnessUser(name: name, email: email);

      await FitnessUserController.saveUserData(credential.user!.uid, user);

      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      _showErrorDialog(FirebaseAuthExceptions(e.code).message, context);
    } catch (e) {
      Navigator.of(context).pop();
    }
  }

  static Future<void> loginUser(
      String email, String password, BuildContext context) async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      print("Error code: ${e.code}");
      print("Error message: ${e.message}");
      Navigator.of(context).pop();
      _showErrorDialog(FirebaseAuthExceptions(e.code).message, context);
    }
  }

  static Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print("Error code: ${e.code}");
      print("Error message: ${e.message}");
      _showErrorDialog(FirebaseAuthExceptions(e.code).message, context);
    }
  }

  static void signOut(){
    FirestoreServices.auth.signOut();
  }
}
