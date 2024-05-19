import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../workout/screens/workout_details_screen.dart';

class ProgressWorkoutsData extends StatelessWidget {
  final Stream? workoutsStream;
  final List<Map<String, dynamic>> userWorkouts;

  const ProgressWorkoutsData({
    Key? key,
    required this.workoutsStream,
    required this.userWorkouts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return StreamBuilder(
      stream: workoutsStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Ошибка: ${snapshot.error}'),
          );
        } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              '',
            ),
          );
        } else {
          List<DocumentSnapshot> workoutDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: userWorkouts.length,
            itemBuilder: (context, index) {
              var workoutProgress = userWorkouts[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    workoutProgress["workoutName"],
                    style: theme.textTheme.titleLarge,
                  ),
                  leading: const Icon(
                    Icons.done,
                    color: MyColors.accent,
                    size: 40,
                  ),
                  subtitle: Text(
                    workoutProgress["workoutDescription"],
                    style: theme.textTheme.bodySmall,
                  ),
                  onTap: () {
                    String workoutId = workoutProgress["workoutId"];
                    DocumentSnapshot<Object?>? workoutSnapshot;
                    for (var doc in workoutDocs) {
                      if (doc.id == workoutId) {
                        workoutSnapshot = doc;
                        break;
                      }
                    }
                    if (workoutSnapshot != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkoutDetailsScreen(
                            workoutSnapshot: workoutSnapshot!,
                          ),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Тренировка удалена'),
                          content: const Text(
                              'К сожалению, эта тренировка была удалена и теперь недоступна для просмотра.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'OK',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}
