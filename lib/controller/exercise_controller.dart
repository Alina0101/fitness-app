import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/controller/firestore_services.dart';
import '../model/models/exercise.dart';

class ExerciseController {
  static Future<void> saveExerciseData(
      String exerciseId, Exercise exercise) async {
    await FirestoreServices.firestore
        .collection("Exercises")
        .doc(exerciseId)
        .set(exercise.toJson());
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getExerciseById(String exerciseId) {
    return FirestoreServices.firestore
        .collection("Exercises")
        .doc(exerciseId)
        .get();
  }

  static Stream<QuerySnapshot> getExercisesListData() {
    return FirestoreServices.currentUserExercisesCollection.snapshots();
  }

  static Stream<QuerySnapshot> getExercisesData() {
    return FirestoreServices.firestore
        .collection("Exercises").snapshots();
  }

  static Future<void> updateExerciseData(
      String exerciseId, Exercise exercise) async {
    await FirestoreServices.firestore
        .collection("Exercises")
        .doc(exerciseId)
        .update(exercise.toJson());
  }

  static Future<void> deleteExerciseData(String exerciseId) async {
    await FirestoreServices.firestore
        .collection("Exercises")
        .doc(exerciseId)
        .delete();
  }

  static Future<void> updateExerciseStatus(
      String exerciseId, bool isCompleted) async {
    await FirestoreServices.firestore
        .collection("Exercises")
        .doc(exerciseId)
        .update({'isCompleted': isCompleted});
  }
}
