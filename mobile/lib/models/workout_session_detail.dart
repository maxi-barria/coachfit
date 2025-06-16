class WorkoutSet {
  final int index;
  final double weight;
  final int reps;
  final int oneRM;

  WorkoutSet({
    required this.index,
    required this.weight,
    required this.reps,
    required this.oneRM,
  });

  factory WorkoutSet.fromJson(Map<String, dynamic> json, int index) {
    final double w = (json['weight'] ?? 0).toDouble();
    final int r = json['rep'] ?? 0;
    final int oneRM = (w * (1 + r / 30)).round();

    return WorkoutSet(
      index: index + 1,
      weight: w,
      reps: r,
      oneRM: oneRM,
    );
  }
}

class WorkoutExerciseDetail {
  final String name;
  final int maxOneRM;
  final List<WorkoutSet> sets;

  WorkoutExerciseDetail({
    required this.name,
    required this.maxOneRM,
    required this.sets,
  });

  factory WorkoutExerciseDetail.fromJson(String name, List<dynamic> setsJson) {
    final sets = setsJson
        .asMap()
        .entries
        .map((entry) => WorkoutSet.fromJson(entry.value, entry.key))
        .toList();

    final max1RM = sets.map((s) => s.oneRM).fold<int>(0, (a, b) => a > b ? a : b);

    return WorkoutExerciseDetail(
      name: name,
      maxOneRM: max1RM,
      sets: sets,
    );
  }
}

class WorkoutSessionDetail {
  final String id;
  final String date;
  final String workoutName;
  final int totalSets;
  final int totalReps;
  final int totalVolume;
  final int prs;
  final List<WorkoutExerciseDetail> exercises;

  WorkoutSessionDetail({
    required this.id,
    required this.date,
    required this.workoutName,
    required this.totalSets,
    required this.totalReps,
    required this.totalVolume,
    required this.prs,
    required this.exercises,
  });

  factory WorkoutSessionDetail.fromJson(Map<String, dynamic> json) {
    final sets = json['setSessions'] ?? [];
    final Map<String, List<dynamic>> grouped = {};

    for (final s in sets) {
      final name = s['workoutExercise']['exercise']['name'];
      grouped.putIfAbsent(name, () => []).add(s);
    }

    final exercises = grouped.entries
        .map((entry) => WorkoutExerciseDetail.fromJson(entry.key, entry.value))
        .toList();

    return WorkoutSessionDetail(
      id: json['id'],
      date: json['date'],
      workoutName: json['workout']['name'],
      totalSets: json['summary']?['totalSets'] ?? sets.length,
      totalReps: json['summary']?['totalReps'] ?? 0,
      totalVolume: json['summary']?['totalVolume'] ?? 0,
      prs: 0,
      exercises: exercises,
    );
  }
}
