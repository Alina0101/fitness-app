import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/controller/workout_controller.dart';
import 'package:fitness_app/view/workout/screens/workout_details_screen.dart';
import 'package:fitness_app/view/workout/widgets/workout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:random_string/random_string.dart';
import '../../../model/models/workout.dart';
import '../../../controller/firestore_services.dart';
import '../../../utils/constants/colors.dart';

class WorkoutListScreen extends StatefulWidget {
  WorkoutListScreen({super.key});

  @override
  State<WorkoutListScreen> createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  Stream? workoutsStream;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getWorkoutsStream();
  }

  getWorkoutsStream() async {
    workoutsStream = await WorkoutController.getWorkoutsData();
    setState(() {});
  }

  Future<void> createWorkout() async {
    nameController.clear();
    descriptionController.clear();

    showDialog(
      context: context,
      builder: (context) => WorkoutDialog(
        titleText: "Новая тренировка",
        nameController: nameController,
        descriptionController: descriptionController,
        onUpdate: saveWorkout,
      ),
    );
  }

  saveWorkout() async {
    //String id = randomAlphaNumeric(10);
    String id = "workout_${randomAlphaNumeric(10)}";
    Workout newWorkout = Workout(
      name: nameController.text.trim(),
      id: id,
      userOwnerId: FirestoreServices.currentUser.uid,
      description: descriptionController.text.trim(),
    );

    await WorkoutController.saveWorkoutData(id, newWorkout);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text("Тренировка добавлена. Теперь добавьте упражнения"),
      ),
    );

    var newWorkoutSnapshot = await WorkoutController.getWorkoutById(id);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            WorkoutDetailsScreen(workoutSnapshot: newWorkoutSnapshot),
      ),
    );
  }

  deleteWorkout(String id) async {
    await WorkoutController.deleteWorkoutData(id).then((value) => {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Тренировка удалена")))
        });
  }

  Widget allWorkoutsData() {
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
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('Добавьте тренировки'),
          );
        } else {
          List<DocumentSnapshot> workoutDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: workoutDocs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = workoutDocs[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
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
                          icon: Icons.delete,
                          backgroundColor: MyColors.delete,
                          onPressed: (context) {
                            deleteWorkout(ds["id"]);
                          }),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      ds["name"],
                      style: theme.textTheme.titleLarge,
                    ),
                    leading: Icon(
                      LineAwesomeIcons.clipboard_list,
                      color: theme.primaryColor,
                      size: 50,
                    ),
                    subtitle: Text(
                      ds["description"],
                      style: theme.textTheme.bodySmall,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              WorkoutDetailsScreen(workoutSnapshot: ds),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Тренировки",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
            onPressed: createWorkout,
            icon: const Icon(Icons.add, size: 30,),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: allWorkoutsData(),
          ),
        ],
      ),
    );
  }
}
