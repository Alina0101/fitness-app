import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/controller/fitness_user_controller.dart';
import 'package:fitness_app/controller/workout_controller.dart';
import 'package:fitness_app/controller/workout_progress_controller.dart';
import 'package:fitness_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fitness_app/controller/firestore_services.dart';

import '../../workout/screens/workout_details_screen.dart';

class Progress extends StatefulWidget {
  Progress({super.key});

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  late Map<String, List<Map<String, dynamic>>> userProgress = {};
  late DateTime firstDate = DateTime.now();
  late DateTime lastDate = DateTime.now();
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDate;

  Stream? workoutsStream;

  @override
  void initState() {
    super.initState();
    getUserProgress();
    getWorkoutsStream();
  }

  getWorkoutsStream() async {
    workoutsStream = await WorkoutController.getWorkoutsData();
    setState(() {});
  }

  Future<void> getUserProgress() async {
    try {
      var progress = await WorkoutProgressController.getUserProgress();
      setState(() {
        userProgress = progress;
        firstDate = findMinDate();
        lastDate = findMaxDate();
      });
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ошибка'),
          content: Text('Произошла ошибка при загрузке прогресса: $error'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  DateTime findMinDate() {
    if (userProgress.isEmpty) {
      return DateTime.now();
    }

    DateTime minDate = DateTime.utc(9999);

    for (var dateStr in userProgress.keys) {
      List<String> parts = dateStr.split('-');
      int year = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int day = int.parse(parts[2]);
      DateTime date = DateTime(year, month, day);

      if (date.isBefore(minDate)) {
        minDate = date;
      }
    }
    return minDate;
  }

  DateTime findMaxDate() {
    if (userProgress.isEmpty) {
      return DateTime.now();
    }

    DateTime maxDate = DateTime.utc(0);

    for (var dateStr in userProgress.keys) {
      List<String> parts = dateStr.split('-');
      int year = int.parse(parts[0]);
      int month = int.parse(parts[1]) + 1;
      int day = int.parse(parts[2]);
      DateTime date = DateTime(year, month, day);

      if (date.isAfter(maxDate)) {
        maxDate = date;
      }
    }
    return maxDate;
  }

  List<Map<String, dynamic>> listOfDayWorkouts(DateTime dateTime) {
    String formattedDate = DateFormat('yyyy-M-d').format(dateTime);

    if (userProgress.containsKey(formattedDate)) {
      return List<Map<String, dynamic>>.from(userProgress[formattedDate]!);
    } else {
      return [];
    }
  }

  Widget progressWorkoutsData(List<Map<String, dynamic>> userWorkouts) {
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
                              workoutSnapshot: workoutSnapshot!),
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
                                    fontWeight: FontWeight.bold, fontSize: 15),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:  Text("Календарь прогресса", style: theme.textTheme.headlineMedium,),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TableCalendar(
                focusedDay: focusedDay,
                firstDay: firstDate,
                lastDay: lastDate,
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.primaryColor,
                  ),
                  todayDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.primaryColor.withOpacity(0.5),
                  ),
                  markerDecoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: MyColors.accent,
                  ),
                  markersMaxCount: 10,
                  //outsideDaysVisible: false,
                ),
                onDaySelected: (selectedDay, fd) {
                  if (!isSameDay(selectedDate, selectedDay)) {
                    setState(() {
                      selectedDate = selectedDay;
                      focusedDay = fd;
                    });
                  }
                },
                selectedDayPredicate: (day) {
                  return isSameDay(selectedDate, day);
                },
                onPageChanged: (fd) {
                  focusedDay = fd;
                },
                eventLoader: listOfDayWorkouts,
              ),
              Container(
                  width: screenWidth,
                  height: screenHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 10),
                        child: Text(
                          "Тренировки за ${selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate!) : DateFormat('yyyy-MM-dd').format(focusedDay)}:",
                          style: theme.textTheme.titleLarge

                        ),
                      ),
                      Expanded(
                        child: progressWorkoutsData(
                            listOfDayWorkouts(selectedDate ?? focusedDay)),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
