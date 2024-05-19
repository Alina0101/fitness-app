import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/models/exercise.dart';
import '../model/models/fitness_user.dart';
import '../model/models/workout.dart';
import '../model/models/workout_progress.dart';

class FirestoreServices {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseAuth auth = FirebaseAuth.instance;

  static User get currentUser => auth.currentUser!;

  static var usersCollection = firestore.collection("Users");

  static var currentUserExercisesCollection = firestore
      .collection("Exercises")
      .where('userOwnerId', isEqualTo: currentUser.uid);

  static var currentUserWorkoutsCollection = firestore
      .collection("Workouts")
      .where('userOwnerId', isEqualTo: currentUser.uid);
}
