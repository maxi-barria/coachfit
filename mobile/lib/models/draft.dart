class SetDraft {
  int reps;
  double weight;
  String? intensityIndicatorId; // debe ser UUID o null
  int restSeconds;

  SetDraft({
    this.reps = 8,
    this.weight = 20,
    this.intensityIndicatorId,
    this.restSeconds = 60,
  });

  Map<String, dynamic> toJson() => {
    'repetition': reps,
    'weight': weight,
    'intensityIndicatorId': intensityIndicatorId,
    'restSeconds': restSeconds,
  };
}

class ExerciseDraft {
  final String exerciseId;
  final String exerciseName;
  List<SetDraft> sets;

  ExerciseDraft({
    required this.exerciseId,
    required this.exerciseName,
    this.sets = const [],
  });

  Map<String, dynamic> toJson() => {
    'exerciseId': exerciseId,
    'sets': sets.map((s) => s.toJson()).toList(),
  };
}

class WorkoutDraft {
  String name;
  DateTime date;
  List<ExerciseDraft> exercises;

  WorkoutDraft({
    required this.name,
    required this.date,
    this.exercises = const [],
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'date': date.toIso8601String(),
    'exercises': exercises.map((e) => e.toJson()).toList(),
  };
}

class RoutineDraft {
  String name;
  String goal;
  DateTime? start;
  DateTime? end;
  List<WorkoutDraft> workouts;

  RoutineDraft({
    required this.name,
    required this.goal,
    this.start,
    this.end,
    this.workouts = const [],
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'goal': goal,
    'startDate': (start ?? DateTime.now()).toIso8601String(),
    'endDate': (end ?? DateTime.now()).toIso8601String(),
    'workouts': workouts.map((w) => w.toJson()).toList(),
  };
}
