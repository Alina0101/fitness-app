import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/controller/workout_controller.dart';
import 'package:fitness_app/view/workout/screens/workout_details_screen.dart';
import 'package:fitness_app/controller/context_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';
import 'firestore_services.dart';

class UniController {

  static init() async {
    try {
      final Uri? uri = await getInitialUri();
      handleWorkoutDeepLink(uri);
    } on PlatformException {
      print("Не удалось получить deep link");
    } on FormatException {
      print("Неверный формат deep link");
    }
    uriLinkStream.listen((Uri? uri) async {
      handleWorkoutDeepLink(uri);
    }, onError: (error) {
      print("Ошибка при обработке deep link: $error");
    });
  }

  static handleWorkoutDeepLink(Uri? uri) async {
    if (uri == null) return;

    String? workoutId = uri.queryParameters['id'];

    if (workoutId != null) {
      DocumentSnapshot workoutSnapshot =
          await WorkoutController.getWorkoutById(workoutId);

      if (workoutSnapshot.exists) {
        Navigator.push(
          ContextUtility.context!,
          MaterialPageRoute(
            builder: (_) =>
                WorkoutDetailsScreen(workoutSnapshot: workoutSnapshot),
          ),
        );
        print("Открыта тренировка с ID: $workoutId");
      } else {
        print("Тренировка с ID $workoutId не найдена");
      }
    }
  }
}
