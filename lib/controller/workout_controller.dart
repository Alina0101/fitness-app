import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/controller/firestore_services.dart';
import '../model/models/workout.dart';

class WorkoutController {
  static Future<void> saveWorkoutData(String workoutId, Workout workout) async {
    await FirestoreServices.firestore.collection("Workouts").doc(workoutId).set(workout.toJson());
  }

  static Stream<QuerySnapshot> getWorkoutsData() {
    return FirestoreServices.currentUserWorkoutsCollection.snapshots();
  }

  static Future<void> updateWorkoutData(
      String workoutId, Workout workout) async {
    await FirestoreServices.firestore
        .collection("Workouts")
        .doc(workoutId)
        .update(workout.toJson());
  }

  static Future<void> updateWorkoutStatus(
      String workoutId, bool isStarted) async {
    await FirestoreServices.firestore
        .collection("Workouts")
        .doc(workoutId)
        .update({'isStarted': isStarted});
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getWorkoutById(
      String workoutId) {
    return FirestoreServices.firestore.collection("Workouts").doc(workoutId).get();
  }

  static Future<void> deleteWorkoutData(String workoutId) async {
    await FirestoreServices.firestore.collection("Workouts").doc(workoutId).delete();
  }

  static Future<void> updateExercisesInWorkoutData(
      String workoutId, List<dynamic> exercises) async {
    await FirestoreServices.firestore
        .collection("Workouts")
        .doc(workoutId)
        .update({'exercises': exercises});
  }

  static Future<void> addExerciseInWorkout(
      String workoutId, String exerciseId) async {
    try {
      DocumentReference workoutRef =
      FirestoreServices.firestore.collection("Workouts").doc(workoutId);

      DocumentSnapshot<Object?> workoutSnapshot = await workoutRef.get();

      Map<String, dynamic> workoutData =
          workoutSnapshot.data() as Map<String, dynamic>? ?? {};
      List<dynamic> currentExercises = workoutData['exercises'] ?? [];

      if (currentExercises.contains(exerciseId)) {
        print('Упражнение уже добавлено в тренировку.');
        return;
      }

      List<dynamic> updatedExercises = [exerciseId, ...currentExercises];

      await workoutRef.update({'exercises': updatedExercises});

      print('Упражнение успешно добавлено в тренировку.');
    } catch (error) {
      print('Ошибка при добавлении упражнения в тренировку: $error');
    }
  }
}
