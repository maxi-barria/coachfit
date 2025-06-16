import 'package:flutter/material.dart';
import 'package:mobile/services/exercise/exercise_service.dart';

class ExercisePRTab extends StatefulWidget {
  final String exerciseId;
  const ExercisePRTab({super.key, required this.exerciseId});

  @override
  State<ExercisePRTab> createState() => _ExercisePRTabState();
}

class _ExercisePRTabState extends State<ExercisePRTab> {
  late Future<Map<String, dynamic>?> _prFuture;

  @override
  void initState() {
    super.initState();
    _prFuture = ExerciseService().getExercisePR(widget.exerciseId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _prFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('Aún no tienes PR registrado'));
        }

        final pr = snapshot.data!;
        final date = DateTime.parse(pr['date']).toLocal();

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tu levantamiento máximo:', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              Text('Peso: ${pr['weight']} kg', style: Theme.of(context).textTheme.bodyLarge),
              Text('Repeticiones: ${pr['reps']}', style: Theme.of(context).textTheme.bodyLarge),
              Text('Estimación 1RM: ${pr['estimated1RM']} kg', style: Theme.of(context).textTheme.bodyLarge),
              Text('Fecha: ${date.day}/${date.month}/${date.year}', style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        );
      },
    );
  }
}
