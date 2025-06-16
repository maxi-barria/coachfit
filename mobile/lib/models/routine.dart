import 'package:mobile/models/routine_workout.dart';

class Routine {
  final String id;
  final String name;
  final String goal;
  final DateTime startDate;
  final DateTime endDate;
  final bool editable;
  final int version;
  final List<RoutineWorkout>? routineWorkouts;

  Routine({
    required this.id,
    required this.name,
    required this.goal,
    required this.startDate,
    required this.endDate,
    required this.editable,
    required this.version,
    this.routineWorkouts,
  });

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      id: json['id'],
      name: json['name'],
      goal: json['goal'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      editable: json['editable'],
      version: json['version'],
      routineWorkouts:
          json['routineWorkouts'] != null
              ? (json['routineWorkouts'] as List)
                  .map((e) => RoutineWorkout.fromJson(e))
                  .toList()
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'goal': goal,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}
