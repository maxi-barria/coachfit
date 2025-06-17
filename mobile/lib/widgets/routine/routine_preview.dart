import 'package:flutter/material.dart';
import 'package:mobile/models/draft.dart';

class RoutinePreview extends StatelessWidget {
  final RoutineDraft draft;
  const RoutinePreview({super.key, required this.draft});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(draft.name, style: Theme.of(context).textTheme.titleLarge),
        if (draft.goal.isNotEmpty) Text('Objetivo: ${draft.goal}'),
        const Divider(height: 24),
        ...draft.workouts.map((w) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(w.name,
                    style: Theme.of(context).textTheme.titleMedium),
                ...w.exercises.map((e) => Padding(
                      padding: const EdgeInsets.only(left: 8, top: 4),
                      child: Text(
                          '• ${e.exerciseName}: ${e.sets.map((s) => s.reps).join('/')} reps'),
                    )),
                const SizedBox(height: 12),
              ],
            )),
      ],
    );
  }
}
