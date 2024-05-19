import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/controller/firestore_services.dart';
import '../model/models/fitness_user.dart';
import '../model/models/workout_progress.dart';

class WorkoutProgressController {
  static Future<void> saveWorkoutProgress(
      String userId,
      String workoutId,
      String workoutName,
      String workoutDescription,
      ) async {
    try {
      DateTime now = DateTime.now();
      String formattedDate = '${now.year}-${now.month}-${now.day}';

      var userRef = FirestoreServices.firestore.collection("Users").doc(userId);

      DocumentSnapshot userSnapshot = await userRef.get();

      Map<String, dynamic>? userData =
      userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
        var progress = Map<String, List<dynamic>>.from(
          userData['progress'] ?? {},
        );

        WorkoutProgress wp = WorkoutProgress(
          workoutId: workoutId,
          workoutName: workoutName,
          workoutDescription: workoutDescription,
        );

        if (progress.containsKey(formattedDate)) {
          if (!progress[formattedDate]!
              .any((element) => element['workoutId'] == workoutId)) {
            progress[formattedDate]!.add(wp.toJson());
          }
        } else {
          progress[formattedDate] = [wp.toJson()];
        }

        await userRef.update({'progress': progress});
      }
    } catch (error) {
      print('Ошибка при сохранении прогресса тренировки: $error');
    }
  }

  static Future<Map<String, List<Map<String, dynamic>>>>
  getUserProgress() async {
    try {
      var userSnapshot = await FirestoreServices.usersCollection
          .doc(FirestoreServices.currentUser.uid)
          .get();
      var userData = userSnapshot.data();
      if (userData != null && userData['progress'] != null) {
        var progress = Map<String, List<Map<String, dynamic>>>.from(
            userData['progress']!.map((key, value) => MapEntry(
              key,
              List<Map<String, dynamic>>.from(
                  value.map((item) => Map<String, dynamic>.from(item))),
            )));
        return progress;
      }
    } catch (error) {
      print('Ошибка при получении прогресса пользователя: $error');
    }
    return {};
  }
}
