import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/controller/firestore_services.dart';
import '../model/models/fitness_user.dart';
import '../model/models/workout_progress.dart';

class FitnessUserController {
  static bool isUserLoggedIn() {
    return FirestoreServices.auth.currentUser != null;
  }

  static Future<bool> userExists() async {
    return (await FirestoreServices.firestore
            .collection('Users')
            .doc(FirestoreServices.currentUser.uid)
            .get())
        .exists;
  }

  static saveUserData(String userId, FitnessUser user) async {
    await FirestoreServices.usersCollection.doc(userId).set(user.toJson());
  }

  static Future<void> updateUserData(String userId, FitnessUser user) async {
    await FirestoreServices.firestore
        .collection("Users")
        .doc(userId)
        .update(user.toJson());
  }
}
