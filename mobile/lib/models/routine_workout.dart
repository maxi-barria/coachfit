import 'package:mobile/models/routine.dart';
import 'package:mobile/models/workout.dart';

class RoutineWorkout {
  final String id;
  final String routineId;
  final String workoutId;
  final int orden;
  final Routine? routine;
  final Workout? workout;

  RoutineWorkout({
    required this.id,
    required this.routineId,
    required this.workoutId,
    required this.orden,
    this.routine,
    this.workout,
  });

  factory RoutineWorkout.fromJson(Map<String, dynamic> json) {
    return RoutineWorkout(
      id: json['id'],
      routineId: json['routineId'],
      workoutId: json['workoutId'],
      orden: json['orden'],
      routine: json['routine'] != null ? Routine.fromJson(json['routine']) : null,
      workout: json['workout'] != null ? Workout.fromJson(json['workout']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'routineId': routineId,
      'workoutId': workoutId,
      'orden': orden,
      'routine': routine?.toJson(),
      'workout': workout?.toJson(),
    };
  }
}