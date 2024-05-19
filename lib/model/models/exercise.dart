class Exercise {
  final String name;
  final String id;
  final String userOwnerId;
  final String category;
  final String? description;
  final String? weight;
  final String? reps;
  final String? sets;
  final bool? isCompleted;

  Exercise({
    required this.name,
    required this.id,
    required this.userOwnerId,
    required this.category,
    this.description,
    this.reps,
    this.weight,
    this.sets,
    this.isCompleted,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] ?? '',
      id: json['id'] ?? '',
      userOwnerId: json['userOwnerId'],
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      weight: json['weight'] ?? '',
      reps: json['reps'] ?? '',
      sets: json['sets'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'userOwnerId': userOwnerId,
      'description': description,
      'category': category,
      'weight': weight,
      'reps': reps,
      'sets': sets,
      'isCompleted': isCompleted ?? false,
    };
  }
}
