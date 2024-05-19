import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/view/exercise/screens/category_exercise_screen.dart';

class MuscleGroupCategoryScreen extends StatefulWidget {
  final bool addingExercisesMode;
  final DocumentSnapshot? currentWorkoutSnapshot;

  const MuscleGroupCategoryScreen(
      {super.key,
      required this.addingExercisesMode,
      this.currentWorkoutSnapshot});

  @override
  State<MuscleGroupCategoryScreen> createState() =>
      _MuscleGroupCategoryScreenState();
}

class _MuscleGroupCategoryScreenState extends State<MuscleGroupCategoryScreen> {
  final List<String> muscleGroups = [
    'Плечи',
    'Спина',
    'Грудь',
    'Руки',
    'Пресс',
    'Ягодицы',
    'Ноги',
  ];

  final List<String> muscleGroupsImages = [
    'assets/muscle/shoulders.jpeg',
    'assets/muscle/back.jpeg',
    'assets/muscle/breast.jpeg',
    'assets/muscle/hands.jpeg',
    'assets/muscle/abs.jpeg',
    'assets/muscle/buttocks.jpeg',
    'assets/muscle/legs.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.addingExercisesMode,
        title: Text(
          'Группы мышц',
          style: theme.textTheme.headlineMedium,
        ),
        actions: [
          if (widget.addingExercisesMode)
            IconButton(
              onPressed: () {
                Navigator.pop(context, widget.currentWorkoutSnapshot);
              },
              icon: const Icon(Icons.done_all),
              iconSize: 25,
            ),
        ],
      ),
      body: ListView.builder(
        itemCount: muscleGroups.length,
        itemBuilder: (context, index) {
          final category = muscleGroups[index];
          final imagePath = muscleGroupsImages[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryExerciseScreen(
                    category: category,
                    addingExercisesMode: widget.addingExercisesMode,
                    currentWorkoutSnapshot: widget.currentWorkoutSnapshot,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      category,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
