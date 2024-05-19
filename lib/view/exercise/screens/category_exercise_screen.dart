import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/controller/exercise_controller.dart';
import 'package:fitness_app/controller/workout_controller.dart';
import 'package:fitness_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../model/models/exercise.dart';
import '../../../controller/firestore_services.dart';
import '../widgets/exercise_dialog.dart';
import 'exercise_details_screen.dart';
import 'package:random_string/random_string.dart';

class CategoryExerciseScreen extends StatefulWidget {
  final String category;
  final bool addingExercisesMode;
  final DocumentSnapshot? currentWorkoutSnapshot;

  const CategoryExerciseScreen(
      {super.key,
      required this.category,
      required this.addingExercisesMode,
      this.currentWorkoutSnapshot});

  @override
  State<CategoryExerciseScreen> createState() => _CategoryExerciseScreenState();
}

class _CategoryExerciseScreenState extends State<CategoryExerciseScreen> {
  Stream? exercisesStream;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController repsController = TextEditingController();
  final TextEditingController setsController = TextEditingController();

  List<String> selectedExercises = [];

  String? selectedMuscleGroup;

  final List<String> muscleGroups = [
    'Грудь',
    'Плечи',
    'Спина',
    'Ноги',
    'Пресс',
    'Руки',
  ];

  @override
  void initState() {
    getExercisesStream();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    weightController.dispose();
    repsController.dispose();
    setsController.dispose();
    super.dispose();
  }

  getExercisesStream() async {
    exercisesStream = await ExerciseController.getExercisesListData();
    setState(() {});
  }

  void clearControllers() {
    nameController.clear();
    descriptionController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  updateExercise(String id) async {
    Exercise updatedExercise = Exercise(
      name: nameController.text.trim(),
      id: id,
      userOwnerId: FirestoreServices.currentUser.uid,
      category: selectedMuscleGroup ?? widget.category,
      description: descriptionController.text.trim(),
      weight: weightController.text.trim(),
      reps: repsController.text.trim(),
      sets: setsController.text.trim(),
    );

    await ExerciseController.updateExerciseData(id, updatedExercise);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Упражнение изменено")),
    );
  }

  deleteExercise(String id) async {
    await ExerciseController.deleteExerciseData(id).then((value) => {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Упражнение удалено")))
        });
  }

  Future<void> editExercise(String id) async {
    showDialog(
      context: context,
      builder: (context) => EditExerciseDialog(
        titleText: "Редактирование",
        nameController: nameController,
        descriptionController: descriptionController,
        weightController: weightController,
        repsController: repsController,
        setsController: setsController,
        selectedCategory: widget.category,
        muscleGroups: muscleGroups,
        exerciseId: id,
        onUpdate: updateExercise,
      ),
    );
  }

  saveExercise(String id) async {
    Exercise newExercise = Exercise(
        name: nameController.text.trim(),
        id: id,
        userOwnerId: FirestoreServices.currentUser.uid,
        category: selectedMuscleGroup ?? widget.category,
        description: descriptionController.text.trim(),
        weight: weightController.text.trim(),
        reps: repsController.text.trim(),
        sets: setsController.text.trim());
    await ExerciseController.saveExerciseData(id, newExercise).then((value) => {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Упражнение создано"))),
        });
    //}
  }

  Future<void> createExercise() async {
    //String id = randomAlphaNumeric(10);
    String id = "exercise_${randomAlphaNumeric(10)}";
    showDialog(
      context: context,
      builder: (context) => EditExerciseDialog(
        titleText: "Новое упражнение",
        nameController: nameController,
        descriptionController: descriptionController,
        weightController: weightController,
        repsController: repsController,
        setsController: setsController,
        selectedCategory: widget.category,
        muscleGroups: muscleGroups,
        exerciseId: id,
        onUpdate: saveExercise,
      ),
    );
  }

  void toggleSelectedExercise(String exerciseId) {
    setState(() {
      if (selectedExercises.contains(exerciseId)) {
        selectedExercises.remove(exerciseId);
      } else {
        selectedExercises.insert(0, exerciseId);
      }
    });
  }

  Widget allExercisesData() {
    final theme = Theme.of(context);
    return StreamBuilder(
      stream: exercisesStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Ошибка: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('Добавьте упражнения'),
          );
        } else {
          List<DocumentSnapshot> filteredExercises = snapshot.data!.docs
              .where((exercise) => exercise['category'] == widget.category)
              .toList();
          return ListView.builder(
            itemCount: filteredExercises.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = filteredExercises[index];
              bool isSelected = selectedExercises.contains(ds.id);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Slidable(
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        icon: Icons.create,
                        backgroundColor: MyColors.edit,
                        onPressed: (context) {
                          nameController.text = ds["name"];
                          descriptionController.text = ds["description"];
                          weightController.text = ds["weight"];
                          repsController.text = ds["reps"];
                          setsController.text = ds["sets"];
                          editExercise(ds["id"]);
                        },
                      ),
                      SlidableAction(
                        icon: Icons.delete,
                        backgroundColor: MyColors.delete,
                        onPressed: (context) {
                          deleteExercise(ds["id"]);
                        },
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      if (widget.addingExercisesMode) {
                        toggleSelectedExercise(ds["id"]);
                        setState(() {
                          isSelected = !isSelected;
                        });
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              ExerciseDetailsScreen(exerciseSnapshot: ds),
                        );
                      }
                    },
                    child: ListTile(
                      title: Text(
                        ds["name"],
                        style: theme.textTheme.titleLarge,
                      ),
                      leading: Icon(LineAwesomeIcons.dumbbell,
                          color: theme.primaryColor, size: 30),
                      trailing: widget.addingExercisesMode
                          ? Checkbox(
                              value: isSelected,
                              onChanged: (value) {
                                toggleSelectedExercise(ds["id"]);
                                setState(() {
                                  isSelected = !isSelected;
                                });
                              },
                            )
                          : const Icon(
                              Icons.info_outline_rounded,
                              color: MyColors.primary,
                              size: 30,
                            ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<void> saveSelectedExercisesToWorkout() async {
    for (final exerciseId in selectedExercises) {
      await WorkoutController.addExerciseInWorkout(
          widget.currentWorkoutSnapshot!.id, exerciseId);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Упражнения добавлены в тренировку")),
    );
    Navigator.pop(context, widget.currentWorkoutSnapshot);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          widget.addingExercisesMode
              ? IconButton(
                  onPressed: () {
                    saveSelectedExercisesToWorkout();
                    Navigator.pop(context, widget.currentWorkoutSnapshot);
                  },
                  icon: const Icon(Icons.done),
                  iconSize: 25,
                )
              : IconButton(
                  onPressed: () {
                    createExercise();
                    clearControllers();
                  },
                  icon: const Icon(Icons.add, size: 30,),
                ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: allExercisesData(),
          ),
        ],
      ),
    );
  }
}
