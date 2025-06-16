import 'package:mobile/models/set_workout.dart';

class IntensityIndicator {
  final String id;
  final String name;
  final String? description;
  final int? value;
  final List<SetWorkout> sets;

  IntensityIndicator({
    required this.id,
    required this.name,
    this.description,
    this.value,
    this.sets = const [],
  });

  factory IntensityIndicator.fromJson(Map<String, dynamic> json) {
    return IntensityIndicator(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      value: json['value'],
      sets: json['sets'] != null
          ? (json['sets'] as List).map((e) => SetWorkout.fromJson(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'value': value,
      'sets': sets.map((e) => e.toJson()).toList(),
    };
  }
}
