import 'package:mobile/models/routine_workout.dart';
import 'package:mobile/models/workout_exercise.dart';
import 'package:mobile/models/workout_session.dart';

class Workout {
  final String id;
  final String userId;
  final String name;
  final DateTime date;
  final String? note;
  int? secondsDuration;
  final List<WorkoutExercise> workoutExercises;
  final List<RoutineWorkout> routineWorkouts;
  final List<WorkoutSession> workoutSessions;

  Workout({
    required this.id,
    required this.userId,
    required this.name,
    required this.date,
    this.note,
    this.secondsDuration,
    this.workoutExercises = const [],
    this.routineWorkouts = const [],
    this.workoutSessions = const [],
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      date: DateTime.parse(json['date']),
      note: json['note'],
      secondsDuration: json['secondsDuration'],
      workoutExercises: json['workoutExercises'] != null
          ? (json['workoutExercises'] as List)
              .map((e) => WorkoutExercise.fromJson(e))
              .toList()
          : [],
      routineWorkouts: json['routineWorkouts'] != null
          ? (json['routineWorkouts'] as List)
              .map((e) => RoutineWorkout.fromJson(e))
              .toList()
          : [],
      workoutSessions: json['workoutSessions'] != null
          ? (json['workoutSessions'] as List)
              .map((e) => WorkoutSession.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'date': date.toIso8601String(),
      'note': note,
      'secondsDuration': secondsDuration,
      'workoutExercises': workoutExercises.map((e) => e.toJson()).toList(),
      'routineWorkouts': routineWorkouts.map((e) => e.toJson()).toList(),
      'workoutSessions': workoutSessions.map((e) => e.toJson()).toList(),
    };
  }
}