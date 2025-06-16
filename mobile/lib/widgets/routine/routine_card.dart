import 'package:flutter/material.dart';
import 'package:mobile/models/routine.dart';
import 'package:mobile/providers/workout_status_provider.dart';
import 'package:mobile/themes/themes.dart';
import 'package:provider/provider.dart';

class RoutineCard extends StatelessWidget {
  final Routine routine;

  const RoutineCard({
    required this.routine,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Iniciar Workout'),
            content: const Text('¿Deseas comenzar esta rutina ahora?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Comenzar'),
              ),
            ],
          ),
        );

        if (confirm == true) {
          final workouts = routine.routineWorkouts;
          if (workouts != null && workouts.isNotEmpty) {
            final workout = workouts.first.workout;
            if (workout != null) {
              final provider =
                  Provider.of<WorkoutStatusProvider>(context, listen: false);
              provider.startWorkout(workout);
              Navigator.pushNamed(context, 'workout', arguments: workout);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Esta rutina no tiene workout asignado.')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Esta rutina no tiene workouts.')),
            );
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera de rutina
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  routine.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Icon(Icons.play_arrow, color: MyTheme.primary),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.red, size: 16),
                const SizedBox(width: 4),
                Text(
                  routine.startDate.toString().substring(0, 10),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Ejercicios por workout',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 6),

            // Lista de workouts
            if (routine.routineWorkouts != null &&
                routine.routineWorkouts!.isNotEmpty)
              ...routine.routineWorkouts!.map((rw) {
                final workout = rw.workout;
                if (workout == null) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Día ${rw.orden} – ${workout.name}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),

                      // Lista de ejercicios
                      ...?workout.workoutExercises?.map((we) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0, bottom: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.fitness_center,
                                      size: 14, color: Colors.black87),
                                  const SizedBox(width: 4),
                                  Text(
                                    we.exercise.name,
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),

                              // Lista de sets
                              ...?we.sets.map((set) => Padding(
                                    padding: const EdgeInsets.only(left: 24.0, top: 1),
                                    child: Text(
                                      '${set.repetition} reps – ${set.weight} kg – ${set.restSeconds}s descanso',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontSize: 12,
                                            color: Colors.grey[700],
                                          ),
                                    ),
                                  )),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                );
              })
            else
              const Text('No hay workouts'),
          ],
        ),
      ),
    );
  }
}
