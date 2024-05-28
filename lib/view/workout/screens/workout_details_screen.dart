import 'package:fitness_app/controller/exercise_controller.dart';
import 'package:fitness_app/controller/fitness_user_controller.dart';
import 'package:fitness_app/controller/workout_controller.dart';
import 'package:fitness_app/controller/workout_progress_controller.dart';
import 'package:fitness_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

import '../../../model/models/exercise.dart';
import '../../../model/models/workout.dart';
import '../../../controller/firestore_services.dart';
import '../../exercise/screens/category_list_screen.dart';
import '../widgets/edit_exercise_dialog.dart';
import '../widgets/exercises_list.dart';
import '../widgets/workout_dialog.dart';

class WorkoutDetailsScreen extends StatefulWidget {
  DocumentSnapshot workoutSnapshot;

  WorkoutDetailsScreen({Key? key, required this.workoutSnapshot});

  @override
  State<WorkoutDetailsScreen> createState() => _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState extends State<WorkoutDetailsScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController setsExerciseController = TextEditingController();
  final TextEditingController repsExerciseController = TextEditingController();
  final TextEditingController weightExerciseController =
      TextEditingController();
  bool addingExercisesMode = false;
  bool isStartOfWorkout = false;
  late Stream<QuerySnapshot> exercisesStream = const Stream.empty();

  @override
  void initState() {
    super.initState();
    initializeControllers();
    getExercisesStream();
    getUpdatedWorkoutSnapshot();
  }

  getExercisesStream() async {
    setState(() {
      exercisesStream = ExerciseController.getExercisesData();
    });
  }

  getUpdatedWorkoutSnapshot() async {
    var updatedWorkoutSnapshot =
        await WorkoutController.getWorkoutById(widget.workoutSnapshot['id']);

    setState(() {
      widget.workoutSnapshot = updatedWorkoutSnapshot;
    });
  }

  void initializeControllers() {
    nameController.text = widget.workoutSnapshot['name'] ?? '';
    descriptionController.text = widget.workoutSnapshot['description'] ?? '';
  }

  void navigateToAddExercises() async {
    setState(() {
      addingExercisesMode = true;
    });
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MuscleGroupCategoryScreen(
          addingExercisesMode: true,
          currentWorkoutSnapshot: widget.workoutSnapshot,
        ),
      ),
    );
    getUpdatedWorkoutSnapshot();
    setState(() {
      addingExercisesMode = false;
    });
  }

  Future<void> updateWorkout(
      String id, String newName, String newDescription) async {
    List<dynamic>? workoutExercises =
        List<dynamic>.from(widget.workoutSnapshot["exercises"]);
    Workout updatedWorkout = Workout(
        name: newName,
        id: id,
        userOwnerId: FirestoreServices.currentUser.uid,
        description: descriptionController.text,
        exercisesIds: workoutExercises);

    await WorkoutController.updateWorkoutData(id, updatedWorkout);

    setState(() {
      nameController.text = newName;
      descriptionController.text = newDescription;
    });
  }

  Future<void> startWorkout() async {
    if (isStartOfWorkout) {
      await WorkoutController.updateWorkoutStatus(
          widget.workoutSnapshot["id"], isStartOfWorkout);
      getUpdatedWorkoutSnapshot();
      return;
    }

    List<dynamic>? workoutExercisesIds =
        List<dynamic>.from(widget.workoutSnapshot["exercises"]);

    bool allExercisesCompleted = true;
    for (var exerciseId in workoutExercisesIds) {
      DocumentSnapshot exerciseSnapshot =
          await ExerciseController.getExerciseById(exerciseId);
      if (!exerciseSnapshot["isCompleted"]) {
        allExercisesCompleted = false;
        break;
      }
    }

    if (allExercisesCompleted) {
      await WorkoutController.updateWorkoutStatus(
          widget.workoutSnapshot["id"], isStartOfWorkout);
      if (!isStartOfWorkout) {
        await resetExerciseCompletion();
      }
      await WorkoutProgressController.saveWorkoutProgress(
          widget.workoutSnapshot["userOwnerId"],
          widget.workoutSnapshot["id"],
          widget.workoutSnapshot["name"],
          widget.workoutSnapshot["description"]);
      getUpdatedWorkoutSnapshot();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Предупреждение'),
          content: const Text(
            'Обратите внимание, что тренировка считается завершенной только если выполнены все упражнения, иначе она не сохранится в вашем прогрессе.\n\n'
            'Вы уверены, что хотите завершить тренировку?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  isStartOfWorkout = !isStartOfWorkout;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Отмена',
                  style: TextStyle(color: MyColors.primary, fontSize: 15)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await WorkoutController.updateWorkoutStatus(
                    widget.workoutSnapshot["id"], isStartOfWorkout);
                if (!isStartOfWorkout) {
                  await resetExerciseCompletion();
                }
                getUpdatedWorkoutSnapshot();
              },
              child: const Text(
                'Завершить тренировку',
                style: TextStyle(color: MyColors.primary, fontSize: 15),
              ),
            ),
          ],
        ),
      );
    }
  }

  Future<void> resetExerciseCompletion() async {
    List<dynamic>? workoutExercisesIds =
        List<dynamic>.from(widget.workoutSnapshot["exercises"]);
    for (var exerciseId in workoutExercisesIds) {
      await ExerciseController.updateExerciseStatus(exerciseId, false);
    }
  }

  Future<void> completeExercise(String id, bool isComplete) async {
    await ExerciseController.updateExerciseStatus(id, isComplete);
    getUpdatedWorkoutSnapshot();
  }

  deleteExerciseFromWorkout(String exerciseId) async {
    try {
      List<dynamic>? workoutExercisesIds =
          List<dynamic>.from(widget.workoutSnapshot["exercises"]);

      workoutExercisesIds.remove(exerciseId);

      await WorkoutController.updateExercisesInWorkoutData(
          widget.workoutSnapshot["id"], workoutExercisesIds);

      getUpdatedWorkoutSnapshot();
    } catch (error) {
      print('Ошибка при удалении упражнения: $error');
    }
  }

  updateExerciseInWorkout(String exerciseId) async {
    try {
      var curExercise = await ExerciseController.getExerciseById(exerciseId);

      Exercise updatedExercise = Exercise(
        name: curExercise["name"],
        id: exerciseId,
        userOwnerId: FirestoreServices.currentUser.uid,
        category: curExercise["category"],
        description: curExercise["description"],
        weight: weightExerciseController.text.trim(),
        reps: repsExerciseController.text.trim(),
        sets: setsExerciseController.text.trim(),
      );

      await ExerciseController.updateExerciseData(exerciseId, updatedExercise);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Упражнение изменено")),
      );

      getUpdatedWorkoutSnapshot();
    } catch (error) {
      print('Ошибка при удалении упражнения: $error');
    }
  }

  Future<void> editExerciseInWorkout(String id) async {
    var curExercise = await ExerciseController.getExerciseById(id);

    weightExerciseController.text = curExercise["weight"];
    repsExerciseController.text = curExercise["reps"];
    setsExerciseController.text = curExercise["sets"];
    showDialog(
      context: context,
      builder: (context) => EditExerciseInWorkoutDialog(
        titleText: "Редактирование",
        weightController: weightExerciseController,
        repsController: repsExerciseController,
        setsController: setsExerciseController,
        exerciseId: id,
        onUpdate: updateExerciseInWorkout,
      ),
    );
  }

  Future<void> reorderExercises(int oldInd, int newInd) async {
    List<dynamic> workoutExercisesIds =
        List<dynamic>.from(widget.workoutSnapshot["exercises"]);

    setState(() {
      if (oldInd < newInd) {
        newInd--;
      }
      final ex = workoutExercisesIds.removeAt(oldInd);
      workoutExercisesIds.insert(newInd, ex);
    });

    getUpdatedWorkoutSnapshot();

    await WorkoutController.updateExercisesInWorkoutData(
        widget.workoutSnapshot["id"], workoutExercisesIds);
  }

  Future<void> sendWorkoutLink(String workoutId) async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    String workoutLink = 'https://workout/?id=$workoutId';
    String message =
        'Привет! Хочу поделиться с тобой своей тренировкой. Возможно, тебе тоже пригодится: $workoutLink';

    await Share.share(message);

    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isUserRegistered = FitnessUserController.isUserLoggedIn();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          nameController.text.trim(),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          isUserRegistered
              ? PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  color: Colors.white.withOpacity(0.9),
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      onTap: navigateToAddExercises,
                      child: ListTile(
                        leading: const Icon(Icons.add),
                        title: Text(
                          'Добавить упражнения',
                          style: theme.textTheme.labelSmall,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(Icons.edit),
                        title: Text(
                          'Редактировать',
                          style: theme.textTheme.labelSmall,
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => WorkoutDialog(
                            titleText: "Редактирование",
                            nameController: nameController,
                            descriptionController: descriptionController,
                            onUpdate: () {
                              updateWorkout(
                                  widget.workoutSnapshot["id"],
                                  nameController.text.trim(),
                                  descriptionController.text.trim());
                            },
                          ),
                        );
                      },
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(Icons.share),
                        title: Text(
                          'Поделиться тренировкой',
                          style: theme.textTheme.labelSmall,
                        ),
                      ),
                      onTap: () async {
                        await sendWorkoutLink(widget.workoutSnapshot["id"]);
                      },
                    ),
                  ],
                )
              : Container(),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(5),
            child: ListTile(
              title: Text(
                descriptionController.text.isNotEmpty
                    ? descriptionController.text
                    : "Здесь будет описание тренировки",
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: ListOfExercisesData(
              exercisesStream: exercisesStream,
              workoutSnapshot: widget.workoutSnapshot,
              deleteExerciseFromWorkout: deleteExerciseFromWorkout,
              editExerciseInWorkout: editExerciseInWorkout,
              reorderExercises: reorderExercises,
              completeExercise: completeExercise,
            ),
          ),
          isUserRegistered
              ? ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isStartOfWorkout = !isStartOfWorkout;
                    });
                    startWorkout();
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                        const Size(double.infinity, 50)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  child: isStartOfWorkout
                      ? const Text("ЗАКОНЧИТЬ ТРЕНИРОВКУ")
                      : const Text("НАЧАТЬ ТРЕНИРОВКУ"),
                )
              : Container(),
        ],
      ),
    );
  }
}
