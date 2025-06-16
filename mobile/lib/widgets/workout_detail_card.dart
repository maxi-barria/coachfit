import 'package:flutter/material.dart';
import 'package:mobile/themes/themes.dart';

class WorkoutDetailCard extends StatelessWidget {
  final String title;
  final String date;
  final List<WorkoutExerciseDetail> exercises;
  final int totalSets;
  final int prs;

  const WorkoutDetailCard({
    super.key,
    required this.title,
    required this.date,
    required this.exercises,
    required this.totalSets,
    required this.prs,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: MyTheme.darkSurf,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                )),
            const SizedBox(height: 16),
            ...exercises.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.white)),
                          Text('${e.maxOneRM} 1RM',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ...e.sets.map((s) => Padding(
                            padding: const EdgeInsets.only(left: 4, top: 2),
                            child: Row(
                              children: [
                                Text('${s.index}. ',
                                    style: TextStyle(
                                        color: Colors.grey[300], fontSize: 13)),
                                Expanded(
                                  child: Text(
                                    '${s.weight.toInt()}x${s.reps}',
                                    style: TextStyle(
                                        color: Colors.grey[300], fontSize: 13),
                                  ),
                                ),
                                Text(
                                  '${s.oneRM}',
                                  style: TextStyle(
                                      color: Colors.grey[300], fontSize: 13),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.orange, size: 18),
                const SizedBox(width: 4),
                Text(date,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12)),
                const SizedBox(width: 12),
                const Icon(Icons.fitness_center, color: Colors.red, size: 18),
                const SizedBox(width: 4),
                Text('$totalSets',
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12)),
                const SizedBox(width: 12),
                const Icon(Icons.emoji_events, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text('$prs PRs',
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutExerciseDetail {
  final String name;
  final int maxOneRM;
  final List<WorkoutSet> sets;

  const WorkoutExerciseDetail({
    required this.name,
    required this.maxOneRM,
    required this.sets,
  });
}

class WorkoutSet {
  final int index;
  final double weight;
  final int reps;
  final int oneRM;

  const WorkoutSet({
    required this.index,
    required this.weight,
    required this.reps,
    required this.oneRM,
  });
}
