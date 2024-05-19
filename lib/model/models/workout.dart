class Workout {
  final String name;
  final String id;
  final String userOwnerId;
  final String? description;
  final List<dynamic>? exercisesIds;
  bool isStarted;

  Workout({
    required this.name,
    required this.id,
    required this.userOwnerId,
    this.description,
    this.exercisesIds,
    this.isStarted = false,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    List<String>? exercisesIds = [];
    if (json['exercises'] != null) {
      var exerciseList = json['exercises'] as List;
      exercisesIds = exerciseList.map((exerciseJson) => exerciseJson.toString()).toList();
    }

    return Workout(
      name: json['name'] ?? '',
      id: json['id'] ?? '',
      userOwnerId: json['userOwnerId'],
      description: json['description'] ?? '',
      exercisesIds: exercisesIds,
      isStarted: json['isStarted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'userOwnerId': userOwnerId,
      'description': description,
      'exercises': exercisesIds,
      'isStarted': isStarted,
    };
  }
}
