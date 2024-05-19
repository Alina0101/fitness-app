// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../../services/firestore_services.dart';
// import '../../../models/exercise.dart';
// import '../exercise_details_screen.dart';
// import 'exercise_dialog.dart';
// import 'exercise_details_screen.dart';
//
// class AllExercisesData extends StatelessWidget {
//   final Stream? exercisesStream;
//   final String category;
//
//   const AllExercisesData({
//     Key? key,
//     required this.exercisesStream,
//     required this.category,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: exercisesStream,
//       builder: (context, AsyncSnapshot snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (snapshot.hasError) {
//           return Center(
//             child: Text('Ошибка: ${snapshot.error}'),
//           );
//         } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return const Center(
//             child: Text('Нет данных'),
//           );
//         } else {
//           List<DocumentSnapshot> filteredExercises = snapshot.data!.docs
//               .where((exercise) => exercise['category'] == category)
//               .toList();
//           return ListView.separated(
//             itemCount: filteredExercises.length,
//             itemBuilder: (context, index) {
//               DocumentSnapshot ds = filteredExercises[index];
//               return Slidable(
//                 startActionPane: ActionPane(
//                   motion: const DrawerMotion(),
//                   children: [
//                     SlidableAction(
//                       icon: Icons.create,
//                       backgroundColor: Colors.blueGrey,
//                       onPressed: (context) {
//                         showDialog(
//                           context: context,
//                           builder: (context) => EditExerciseDialog(
//                             titleText: "Редактирование",
//                             nameController: nameController,
//                             descriptionController: descriptionController,
//                             weightController: weightController,
//                             repsController: repsController,
//                             setsController: setsController,
//                             selectedCategory: category,
//                             muscleGroups: muscleGroups,
//                             exerciseId: ds["id"],
//                             onUpdate: updateExercise,
//                           ),
//                         );
//                       },
//                     )
//                   ],
//                 ),
//                 endActionPane: ActionPane(
//                   motion: const DrawerMotion(),
//                   children: [
//                     SlidableAction(
//                       icon: Icons.delete,
//                       backgroundColor: Colors.red.shade400,
//                       onPressed: (context) {
//                         deleteExercise(ds["id"]);
//                       },
//                     ),
//                   ],
//                 ),
//                 child: ListTile(
//                   title: Text(ds["name"]),
//                   subtitle: Text(
//                     'Повторения: ${ds["reps"]}\n'
//                         'Подходы: ${ds["sets"]}',
//                   ),
//                   leading: const CircleAvatar(
//                     backgroundColor: Colors.deepPurple,
//                     child: Icon(
//                       Icons.fitness_center,
//                       color: Colors.white,
//                     ),
//                   ),
//                   trailing: const Icon(
//                     Icons.arrow_forward_ios,
//                     color: Colors.deepPurple,
//                   ),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ExerciseDetailsScreen(
//                           exerciseSnapshot: ds,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//             separatorBuilder: (context, index) => const Divider(),
//           );
//         }
//       },
//     );
//   }
// }
