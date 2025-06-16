import 'package:mobile/models/set_session.dart';
import 'package:mobile/models/workout.dart';

class WorkoutSession {
  final String id;
  final String workoutId;
  final DateTime startTime;
  final DateTime? endTime;
  final int? totalDuration;
  final String? notes;
  final Workout? workout;
  final List<SetSession> setSessions;

  WorkoutSession({
    required this.id,
    required this.workoutId,
    required this.startTime,
    this.endTime,
    this.totalDuration,
    this.notes,
    this.workout,
    this.setSessions = const [],
  });

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      id: json['id'],
      workoutId: json['workoutId'],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      totalDuration: json['totalDuration'],
      notes: json['notes'],
      workout: json['workout'] != null ? Workout.fromJson(json['workout']) : null,
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
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'totalDuration': totalDuration,
      'notes': notes,
      'workout': workout?.toJson(),
      'setSessions': setSessions.map((e) => e.toJson()).toList(),
    };
  }
}