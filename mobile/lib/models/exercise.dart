class Exercise {
  final String id;
  final String name;
  final String description;
  final String type;
  final int secondsDuration;
  final dynamic imageUrl;
  final dynamic gifUrl;
  final dynamic userId;
  final bool isCustom;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.secondsDuration,
    required this.imageUrl,
    required this.gifUrl,
    required this.userId,
    required this.isCustom,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown Exercise',
      description:
          json['description']?.toString() ?? 'No descripcion disponible',
      type: json['type']?.toString() ?? 'general',
      secondsDuration:
          json['secondsDuration'] is num ? json['secondsDuration'] : 0,
      imageUrl: json['imageUrl']?.toString(),
      gifUrl: json['gifUrl']?.toString(),
      userId: json['userId']?.toString(),
      isCustom:
          json['isCustom'] == true ||
          json['isCustom']?.toString().toLowerCase() == 'true',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'secondsDuration': secondsDuration,
      'imageUrl': imageUrl,
      'gifUrl': gifUrl,
      'userId': userId,
      'isCustom': isCustom,
    };
  }

  @override
  String toString() {
    return 'Exercise(id: $id, name: $name, type: $type, isCustom: $isCustom)';
  }
}
