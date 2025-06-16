import 'package:flutter/material.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/widgets/custom_app_bar.dart';
import 'package:mobile/widgets/workout_detail_card.dart';

class WorkoutDetailScreen extends StatelessWidget {
  const WorkoutDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> session =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final title = session['workout'] ?? 'Sesión';
    final date = session['date'] ?? '';
    final totalSets = session['summary']['totalSets'] ?? 0;
    final prs = session['prs'] ?? 0;

    final List<Map<String, dynamic>> setData = List<Map<String, dynamic>>.from(
      session['setData'] ?? [],
    );

    // Agrupar sets por nombre de ejercicio
    final Map<String, List<Map<String, dynamic>>> groupedSets = {};

    for (final set in setData) {
      final exerciseName = set['exercise'] ?? 'Ejercicio desconocido';
      if (!groupedSets.containsKey(exerciseName)) {
        groupedSets[exerciseName] = [];
      }
      groupedSets[exerciseName]!.add(set);
    }

    // Construir lista de detalles por ejercicio
    final List<WorkoutExerciseDetail> details = [];

    groupedSets.forEach((exerciseName, sets) {
      final List<WorkoutSet> workoutSets = [];
      int maxOneRM = 0;

      for (int i = 0; i < sets.length; i++) {
        final s = sets[i];
        final oneRM = s['1RM'] ?? 0;

        workoutSets.add(
          WorkoutSet(
            index: i + 1,
            weight: (s['weight'] ?? 0).toDouble(),
            reps: s['rep'] ?? 0,
            oneRM: oneRM,
          ),
        );

        if (oneRM > maxOneRM) maxOneRM = oneRM;
      }

      details.add(
        WorkoutExerciseDetail(
          name: exerciseName,
          maxOneRM: maxOneRM,
          sets: workoutSets,
        ),
      );
    });

    return Scaffold(
      backgroundColor: MyTheme.secondary,
      appBar: const CustomAppBar(title: 'Detalle del Entrenamiento'),
      body: WorkoutDetailCard(
        title: title,
        date: date,
        exercises: details,
        totalSets: totalSets,
        prs: prs,
      ),
    );
  }
}
