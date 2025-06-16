import 'package:mobile/models/workout_exercise.dart';
import 'package:mobile/models/workout_session.dart';

class SetSession {
  final String id;
  final String workoutExerciseId;
  final String workoutSessionId;
  final int repetitionsCompleted;
  final double weightUsed;
  final int restTime;
  final DateTime completedAt;
  final String? notes;
  final WorkoutExercise? workoutExercise;
  final WorkoutSession? workoutSession;

  SetSession({
    required this.id,
    required this.workoutExerciseId,
    required this.workoutSessionId,
    required this.repetitionsCompleted,
    required this.weightUsed,
    required this.restTime,
    required this.completedAt,
    this.notes,
    this.workoutExercise,
    this.workoutSession,
  });

  factory SetSession.fromJson(Map<String, dynamic> json) {
    return SetSession(
      id: json['id'],
      workoutExerciseId: json['workoutExerciseId'],
      workoutSessionId: json['workoutSessionId'],
      repetitionsCompleted: json['repetitionsCompleted'],
      weightUsed: (json['weightUsed'] as num).toDouble(),
      restTime: json['restTime'],
      completedAt: DateTime.parse(json['completedAt']),
      notes: json['notes'],
      workoutExercise: json['workoutExercise'] != null
          ? WorkoutExercise.fromJson(json['workoutExercise'])
          : null,
      workoutSession: json['workoutSession'] != null
          ? WorkoutSession.fromJson(json['workoutSession'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workoutExerciseId': workoutExerciseId,
      'workoutSessionId': workoutSessionId,
      'repetitionsCompleted': repetitionsCompleted,
      'weightUsed': weightUsed,
      'restTime': restTime,
      'completedAt': completedAt.toIso8601String(),
      'notes': notes,
      'workoutExercise': workoutExercise?.toJson(),
      'workoutSession': workoutSession?.toJson(),
    };
  }
}