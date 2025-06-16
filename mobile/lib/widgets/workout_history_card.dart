import 'package:flutter/material.dart';
import 'package:mobile/themes/themes.dart';

class WorkoutHistoryCard extends StatelessWidget {
  final String title;
  final List<String> exercises;
  final List<String> bestSets;
  final String date;
  final int totalSets;
  final int prs;
  final List<int> setCounts;
  final VoidCallback onTap;
  final void Function(String action)? onActionSelected;

  const WorkoutHistoryCard({
    super.key,
    required this.title,
    required this.exercises,
    required this.bestSets,
    required this.date,
    required this.totalSets,
    required this.prs,
    required this.setCounts,
    required this.onTap,
    required this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: MyTheme.darkSurf,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título y menú
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onSelected: onActionSelected,
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'share', child: Text('Compartir')),
                      PopupMenuItem(value: 'edit', child: Text('Editar')),
                      PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Lista de ejercicios y sets
              Column(
                children: List.generate(exercises.length, (index) {
                  final ex = exercises[index];
                  final bs = bestSets.length > index ? bestSets[index] : '';
                  final sets = setCounts.length > index ? setCounts[index] : 0;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "$sets x $ex",
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            bs,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),

              const SizedBox(height: 12),

              // Detalle de fecha, sets totales y PRs
              Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.orange, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    date,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.fitness_center, color: Colors.red, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '$totalSets',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.emoji_events, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '$prs PRs',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
