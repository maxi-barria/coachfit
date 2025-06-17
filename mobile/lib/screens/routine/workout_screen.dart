import 'package:flutter/material.dart';
import 'package:mobile/models/draft.dart';
import 'package:mobile/models/routine_workout.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:mobile/models/workout.dart';
import 'package:mobile/models/set_workout.dart';
import 'package:mobile/models/exercise.dart';
import 'package:mobile/providers/workout_status_provider.dart';
import 'package:mobile/providers/routine_provider.dart';
import 'package:mobile/widgets/routine/workout_exercise_widget.dart';
import 'package:mobile/themes/themes.dart';

// Importa solo los widgets específicos desde add_exercise
import 'package:mobile/widgets/routine/add_exercise_flow.dart'
    show AddExerciseButton, ExercisePickerScreen, SetBuilderDialog;

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key, required this.workout});
  final Workout workout;

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  late Workout _workout;

  /* ---------- helpers ---------- */
  String _fmt(int s) =>
      '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  void initState() {
    super.initState();
    _workout = widget.workout;

    /* registra el workout activo una sola vez */
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ws = context.read<WorkoutStatusProvider>();
      if (ws.activeWorkout == null) ws.startWorkout(_workout);
    });
  }

  /* ---------- acciones ---------- */
  void _finishWorkout() {
    final ws = context.read<WorkoutStatusProvider>();
    _workout.secondsDuration = ws.elapsedSecs;
    ws.endWorkout();
    Navigator.pop(context);
  }

  void _minimizeAndPop() {
    context.read<WorkoutStatusProvider>().minimizeWorkout();
    Navigator.pop(context);
  }

  /* agregar un set solo en UI local (no backend) */
  void _addLocalSet(String workoutExerciseId) {
    setState(() {
      _workout.workoutExercises
          .firstWhere((we) => we.id == workoutExerciseId)
          .sets
          .add(
            SetWorkout(
              id: '',
              workoutExerciseId: workoutExerciseId,
              repetition: 0,
              weight: 0,
              restSeconds: 60,
              createdAt: DateTime.now(),
            ),
          );
    });
  }

  /* ========= flujo “Agregar ejercicio” integrado ========= */
  Future<void> _openAddExerciseFlow() async {
    /* 1. Selector */
    final exercise = await Navigator.push<Exercise?>(
      context,
      MaterialPageRoute(builder: (_) => const ExercisePickerScreen()),
    );
    if (exercise == null) return;

    /* 2. Sets */
    final sets = await showDialog<List<SetDraft>>(
      context: context,
      builder: (_) => SetBuilderDialog(exerciseName: exercise.name),
    );
    if (sets == null || sets.isEmpty) return;

    /* 3. Payload y provider */
    final payload = {
      'exerciseId': exercise.id,
      'sets': sets.map((s) => s.toJson()).toList(),
    };

    final ok = await context.read<RoutineProvider>().addExerciseToWorkout(
      _workout.id,
      payload,
    );
    if (ok && mounted) {
      final updated = context.read<RoutineProvider>().selectedRoutine;

      final routineWorkouts = updated?.routineWorkouts;

      final rw = routineWorkouts?.firstWhereOrNull(
        (rw) => rw.workout?.id == _workout.id,
      );

      final sameWorkout = rw?.workout;

      if (sameWorkout != null) {
        setState(() => _workout = sameWorkout);
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ejercicio agregado')));
    }
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
        floatingActionButton: AddExerciseButton(workoutId: _workout.id),
        appBar: AppBar(
          backgroundColor: MyTheme.backgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: _minimizeAndPop,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _workout.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                _fmt(elapsed),
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyTheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                onPressed: _finishWorkout,
                child: const Text(
                  'Finalizar',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
          ],
        ),

        /* -------- lista de ejercicios -------- */
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _workout.workoutExercises.length,
          itemBuilder: (_, i) {
            final we = _workout.workoutExercises[i];
            return WorkoutExerciseWidget(
              workoutExercise: we,
              onSetCompleted: (_) {},
              onAddSet: () => _addLocalSet(we.id),
            );
          },
        ),
      ),
    );
  }
}
