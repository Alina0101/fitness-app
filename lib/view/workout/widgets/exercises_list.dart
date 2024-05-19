import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:collection/collection.dart';
import '../../../model/models/workout.dart';
import '../../../utils/constants/colors.dart';
import '../../exercise/screens/exercise_details_screen.dart';


class ListOfExercisesData extends StatefulWidget {
  final Stream<QuerySnapshot> exercisesStream;
  final DocumentSnapshot workoutSnapshot;
  final Function(String) deleteExerciseFromWorkout;
  final Function(String) editExerciseInWorkout;
  final Function(int, int) reorderExercises;
  final Function(String, bool) completeExercise;

  const ListOfExercisesData({
    super.key,
    required this.exercisesStream,
    required this.workoutSnapshot,
    required this.deleteExerciseFromWorkout,
    required this.reorderExercises,
    required this.completeExercise,
    required this.editExerciseInWorkout,
  });

  @override
  State<ListOfExercisesData> createState() => _ListOfExercisesDataState();
}

class _ListOfExercisesDataState extends State<ListOfExercisesData> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.exercisesStream,
      builder: (context, snapshot) {
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
                'Чтобы добавить упражнения нажмите на три точки в верхнем правом углу'),
          );
        } else {
          final List<dynamic>? workoutExercisesIds =
              widget.workoutSnapshot["exercises"];
          if (workoutExercisesIds == null) {
            return const Center(
              child: Text(
                'Чтобы добавить упражнения нажмите на три точки в верхнем правом углу',
                textAlign: TextAlign.center,
              ),
            );
          }
          List<DocumentSnapshot> filteredExercises = [];
          workoutExercisesIds.forEach((exerciseId) {
            var exercise = snapshot.data!.docs.firstWhereOrNull(
              (exercise) => exercise.id == exerciseId,
            );
            if (exercise != null) {
              filteredExercises.add(exercise);
            }
          });
          return ReorderableListView.builder(
            itemCount: filteredExercises.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = filteredExercises[index];
              return buildExerciseItem(ds, context, Key(ds.id));
            },
            onReorder: (oldIndex, newIndex) {
              widget.reorderExercises(oldIndex, newIndex)!;
            },
          );
        }
      },
    );
  }

  Widget buildExerciseItem(DocumentSnapshot ds, BuildContext context, Key key) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final Workout workout =
        Workout.fromJson(widget.workoutSnapshot.data() as Map<String, dynamic>);
    bool isCompleted = ds["isCompleted"];
    return Container(
      key: key,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: ds["isCompleted"] ? MyColors.accent : Colors.white,
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
        key: key,
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              icon: Icons.edit,
              backgroundColor: MyColors.edit,
              onPressed: (context) {
                widget.editExerciseInWorkout(ds.id);
              },
            ),
            SlidableAction(
              icon: Icons.delete,
              backgroundColor: MyColors.delete,
              onPressed: (context) {
                widget.deleteExerciseFromWorkout(ds.id);
              },
            ),
          ],
        ),
        child: ListTile(
          key: key,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => ExerciseDetailsScreen(exerciseSnapshot: ds),
            );
          },
          title: Text(
            ds["name"],
            style: const TextStyle(fontSize: 20),
          ),
          subtitle: Row(
            children: [
              Chip(
                label: ds["sets"] != '' && ds["reps"] != ''
                    ? Text(
                  '${ds["reps"]} х ${ds["sets"]}',
                  style: TextStyle(fontWeight: FontWeight.w500),
                )
                    : const Text("0 х 0",
                    style: TextStyle(fontWeight: FontWeight.w500)),
                backgroundColor: MyColors.secondary,
                labelStyle: const TextStyle(color: Colors.white),
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.01,
                    vertical: screenHeight * 0.01),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              SizedBox(
                width: screenWidth * 0.01,
              ),
              Chip(
                label: ds["weight"] != ''
                    ? Text('${ds["weight"]} кг',
                        style: TextStyle(fontWeight: FontWeight.w500))
                    : const Text('0 кг',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                backgroundColor: MyColors.secondary,
                labelStyle: const TextStyle(color: Colors.white),
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.01,
                    vertical: screenHeight * 0.01),
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
          trailing: workout.isStarted
              ? Checkbox(
                  value: isCompleted,
                  onChanged: (value) {
                    setState(() {
                      isCompleted = !isCompleted;
                    });
                    widget.completeExercise(ds["id"], isCompleted);
                  },
                )
              : const Icon(
                  Icons.reorder,
                  color: MyColors.secondary,
                  size: 30,
                ),
        ),
      ),
    );
  }
}
