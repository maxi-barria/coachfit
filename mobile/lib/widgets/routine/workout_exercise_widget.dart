import 'package:flutter/material.dart';
import 'package:mobile/models/set_workout.dart';
import 'package:mobile/models/workout_exercise.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/widgets/routine/set_row.dart';

class WorkoutExerciseWidget extends StatefulWidget {
  final WorkoutExercise workoutExercise;
  final Function(String) onSetCompleted;
  final VoidCallback onAddSet;

  const WorkoutExerciseWidget({
    required this.workoutExercise,
    required this.onSetCompleted,
    required this.onAddSet,
    super.key,
  });

  @override
  State<WorkoutExerciseWidget> createState() => _WorkoutExerciseWidgetState();
}

class _WorkoutExerciseWidgetState extends State<WorkoutExerciseWidget> {
  // Mapa para trackear qué sets están completados (en memoria)
  final Map<String, bool> completedSets = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del ejercicio
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  widget.workoutExercise.exercise.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.primary,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.bar_chart,
                  color: MyTheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.more_vert,
                  color: MyTheme.primary,
                  size: 20,
                ),
              ],
            ),
          ),
          
          // Header de las columnas
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                Expanded(
                  flex: 2,
                  child: Text(
                    "Anterior",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Peso",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Reps",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Rir",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 40),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Sets
          ...widget.workoutExercise.sets.asMap().entries.map((entry) {
            int index = entry.key;
            SetWorkout set = entry.value;
            return SetRow(
              setNumber: index + 1,
              set: set,
              isCompleted: completedSets[set.id] ?? false,
              onCompleted: () {
                setState(() {
                  completedSets[set.id] = !(completedSets[set.id] ?? false);
                });
                widget.onSetCompleted(set.id);
              },
              onWeightChanged: (value) {
                setState(() {
                  set.weight = value;
                });
              },
              onRepsChanged: (value) {
                setState(() {
                  set.repetition = value;
                });
              },
            );
          }).toList(),
          
          // Botón Agregar Serie
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: TextButton(
              onPressed: widget.onAddSet,
              child: const Text(
                "Agregar Serie",
                style: TextStyle(
                  color: MyTheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}