
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mobile/models/workout.dart';
import 'package:mobile/models/set_workout.dart';
import 'package:mobile/providers/workout_status_provider.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/widgets/routine/workout_exercise_widget.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key, required this.workout});
  final Workout workout;

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  late Workout workout;

  /* helpers */
  String _fmt(int s) =>
      '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  void initState() {
    super.initState();
    workout = widget.workout;

    /// registra el workout si nadie lo ha hecho aún
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ws = context.read<WorkoutStatusProvider>();
      if (ws.activeWorkout == null) ws.startWorkout(workout);
    });
  }

  /* ---------------- acciones ---------------- */

  void _finishWorkout() {
    final ws = context.read<WorkoutStatusProvider>();
    workout.secondsDuration = ws.elapsedSecs;
    ws.endWorkout();
    Navigator.pop(context);
  }

  void _minimizeAndPop() {
    context.read<WorkoutStatusProvider>().minimizeWorkout();
    Navigator.pop(context);
  }

  void _addSet(String workoutExerciseId) {
    final newSet = SetWorkout(
      id: '', workoutExerciseId: workoutExerciseId,
      repetition: 0, weight: 0, restSeconds: 60, createdAt: DateTime.now(),
    );

    setState(() {
      workout.workoutExercises
          .firstWhere((we) => we.id == workoutExerciseId)
          .sets
          .add(newSet);
    });
  }

  /* ---------------- UI ---------------- */

  @override
  Widget build(BuildContext context) {
    final elapsed = context.watch<WorkoutStatusProvider>().elapsedSecs;

    return WillPopScope(
      onWillPop: () async {
        _minimizeAndPop();
        return false;
      },
      child: Scaffold(
        backgroundColor: MyTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: MyTheme.backgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: _minimizeAndPop,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(workout.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              Text(_fmt(elapsed),
                  style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyTheme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onPressed: _finishWorkout,
                child: const Text('Finalizar', style: TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: workout.workoutExercises.length,
          itemBuilder: (_, i) {
            final we = workout.workoutExercises[i];
            return WorkoutExerciseWidget(
              workoutExercise: we,
              onSetCompleted: (_) {},
              onAddSet: () => _addSet(we.id),
            );
          },
        ),
      ),
    );
  }
}
