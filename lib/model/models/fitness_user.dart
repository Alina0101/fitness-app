class FitnessUser {
  late String name;
  late String email;
  String? weight;
  String? height;
  String? parameters;
  Map<String, List<Map<String, dynamic>>>? progress = {};

  FitnessUser({
    required this.name,
    required this.email,
    this.weight,
    this.height,
    this.parameters,
    Map<String, List<Map<String, dynamic>>>? progress,
  }) {
    if (progress != null) {
      this.progress = progress;
    }
  }

  FitnessUser.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    weight = json['weight'] ?? '';
    height = json['height'] ?? '';
    parameters = json['parameters'] ?? '';
    if (json['progress'] != null) {
      final Map<String, dynamic> progressJson = json['progress'];
      progressJson.forEach((key, value) {
        progress![key] = List<Map<String, dynamic>>.from(value);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['weight'] = weight;
    data['height'] = height;
    data['parameters'] = parameters;
    // data['progress'] = progress.map((key, value) =>
    //     MapEntry(key, List<dynamic>.from(value.map((e) => e))));
    return data;
  }
}
