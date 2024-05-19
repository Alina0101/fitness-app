class WorkoutProgress {
  late String workoutId;
  late String workoutName;
  late String workoutDescription;

  WorkoutProgress({
    required this.workoutId,
    required this.workoutName,
    required this.workoutDescription,
  });

  WorkoutProgress.fromJson(Map<String, dynamic> json) {
    workoutId = json['workoutId'] ?? '';
    workoutName = json['workoutName'] ?? '';
    workoutDescription = json['workoutDescription'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['workoutId'] = workoutId;
    data['workoutName'] = workoutName;
    data['workoutDescription'] = workoutDescription;
    return data;
  }
}