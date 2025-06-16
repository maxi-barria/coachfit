class WorkoutHistoryEntry {
  final String id;
  final String routineName;
  final DateTime date;
  final int totalVolume;
  final int totalReps;
  final int totalSets;
  final int prCount;
  final List<ExerciseSummary> exercises;

  WorkoutHistoryEntry({
    required this.id,
    required this.routineName,
    required this.date,
    required this.totalVolume,
    required this.totalReps,
    required this.totalSets,
    required this.prCount,
    required this.exercises,
  });

  factory WorkoutHistoryEntry.fromJson(Map<String, dynamic> json) {
    return WorkoutHistoryEntry(
      id: json['id'],
      routineName: json['routineName'],
      date: DateTime.parse(json['date']),
      totalVolume: json['totalVolume'],
      totalReps: json['totalReps'],
      totalSets: json['totalSets'],
      prCount: json['prCount'],
      exercises: (json['exercises'] as List)
          .map((e) => ExerciseSummary.fromJson(e))
          .toList(),
    );
  }
}

class ExerciseSummary {
  final String name;
  final String bestSet;

  ExerciseSummary({
    required this.name,
    required this.bestSet,
  });

  factory ExerciseSummary.fromJson(Map<String, dynamic> json) {
    return ExerciseSummary(
      name: json['name'],
      bestSet: json['bestSet'],
    );
  }
}
