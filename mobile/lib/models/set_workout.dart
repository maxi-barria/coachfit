import 'package:mobile/models/intensity_indicator.dart';
import 'package:mobile/models/workout_exercise.dart';

class SetWorkout {
  final String id;
  final String workoutExerciseId;
  int repetition;
  double weight;
  final String? intensityIndicatorId;
  final int restSeconds;
  final DateTime createdAt;
  final WorkoutExercise? workoutExercise;
  final IntensityIndicator? intensityIndicator;

  SetWorkout({
    required this.id,
    required this.workoutExerciseId,
    required this.repetition,
    required this.weight,
    this.intensityIndicatorId,
    required this.restSeconds,
    required this.createdAt,
    this.workoutExercise,
    this.intensityIndicator,
  });

  factory SetWorkout.fromJson(Map<String, dynamic> json) {
    return SetWorkout(
      id: json['id'],
      workoutExerciseId: json['workoutExerciseId'],
      repetition: json['repetition'],
      weight: (json['weight'] as num).toDouble(),
      intensityIndicatorId: json['intensityIndicatorId'],
      restSeconds: json['restSeconds'],
      createdAt: DateTime.parse(json['createdAt']),
      workoutExercise: json['workoutExercise'] != null
          ? WorkoutExercise.fromJson(json['workoutExercise'])
          : null,
      intensityIndicator: json['intensityIndicator'] != null
          ? IntensityIndicator.fromJson(json['intensityIndicator'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workoutExerciseId': workoutExerciseId,
      'repetition': repetition,
      'weight': weight,
      'intensityIndicatorId': intensityIndicatorId,
      'restSeconds': restSeconds,
      'createdAt': createdAt.toIso8601String(),
      'workoutExercise': workoutExercise?.toJson(),
      'intensityIndicator': intensityIndicator?.toJson(),
    };
  }
}