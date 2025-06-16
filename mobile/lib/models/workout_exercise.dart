// models/workout_exercise.dart
import 'package:mobile/models/exercise.dart';
import 'package:mobile/models/set_session.dart';
import 'package:mobile/models/set_workout.dart';
import 'package:mobile/models/workout.dart';

class WorkoutExercise {
  final String id;
  final String workoutId;
  final String exerciseId;
  final int orden;
  final Workout? workout;
  final Exercise exercise;
  final List<SetWorkout> sets;
  final List<SetSession> setSessions;

  WorkoutExercise({
    required this.id,
    required this.workoutId,
    required this.exerciseId,
    required this.orden,
    this.workout,
    required this.exercise,
    this.sets = const [],
    this.setSessions = const [],
  });

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      id: json['id'],
      workoutId: json['workoutId'],
      exerciseId: json['exerciseId'],
      orden: json['orden'],
      workout: json['workout'] != null ? Workout.fromJson(json['workout']) : null,
      exercise: Exercise.fromJson(json['exercise']),
      sets: json['sets'] != null
          ? (json['sets'] as List).map((e) => SetWorkout.fromJson(e)).toList()
          : [],
      setSessions: json['setSessions'] != null
          ? (json['setSessions'] as List)
              .map((e) => SetSession.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workoutId': workoutId,
      'exerciseId': exerciseId,
      'orden': orden,
      'workout': workout?.toJson(),
      // 'exercise': exercise.toJson(),
      'sets': sets.map((e) => e.toJson()).toList(),
      'setSessions': setSessions.map((e) => e.toJson()).toList(),
    };
  }
}
