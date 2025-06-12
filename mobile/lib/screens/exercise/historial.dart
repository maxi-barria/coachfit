import 'package:flutter/material.dart';
import 'package:mobile/services/exercise/exercise_service.dart';

class ExerciseHistoryTab extends StatefulWidget {
  final String exerciseId;
  const ExerciseHistoryTab({super.key, required this.exerciseId});

  @override
  State<ExerciseHistoryTab> createState() => _ExerciseHistoryTabState();
}

class _ExerciseHistoryTabState extends State<ExerciseHistoryTab> {
  late Future<List<List<Map<String, dynamic>>>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture =
        ExerciseService().getGroupedExerciseHistory(widget.exerciseId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List<Map<String, dynamic>>>>(
      future: _historyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay historial disponible'));
        }

        final groupedSessions = snapshot.data!;
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: groupedSessions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final session = groupedSessions[index];
            final first = session.isNotEmpty ? session.first : null;

            final workoutName = first?['workoutName'] ?? 'Sin nombre';
            final rawDate = first?['date'];
            final dateStr = rawDate != null
                ? DateTime.tryParse(rawDate)?.toLocal().toString().split(' ')[0] ?? 'Fecha inválida'
                : 'Fecha desconocida';

            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workoutName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateStr,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  ...session.map((s) {
                    final rep = s['rep']?.toString() ?? '-';
                    final weight = s['weight']?.toString() ?? '-';
                    final intensity = s['intensity']?.toString() ?? '-';

                    return Text(
                      'Reps: $rep · Peso: $weight kg · RPE: $intensity',
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
