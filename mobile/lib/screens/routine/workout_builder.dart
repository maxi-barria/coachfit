import 'package:flutter/material.dart';
import 'package:mobile/widgets/routine/exercise_set_dialog.dart';
import 'package:mobile/widgets/routine/add_exercise_flow.dart';
import 'package:mobile/models/draft.dart' as draft;

class WorkoutBuilder extends StatefulWidget {
  const WorkoutBuilder({super.key});

  @override
  State<WorkoutBuilder> createState() => WorkoutBuilderState();
}

class WorkoutBuilderState extends State<WorkoutBuilder> {
  final draft.WorkoutDraft _workout =
      draft.WorkoutDraft(name: 'Workout A', date: DateTime.now());
  final TextEditingController _nameCtrl = TextEditingController(text: 'Workout A');

  draft.WorkoutDraft get workout {
    _workout.name = _nameCtrl.text;
    return _workout;
  }

  Future<void> _addExercise(draft.ExerciseDraft ex) async {
    setState(() {
      _workout.exercises = [..._workout.exercises, ex];
    });
  }

  Future<void> _openExerciseFlow() async {
    final exercise = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ExercisePickerScreen()),
    );
    if (exercise == null) return;

    final sets = await showDialog<List<draft.SetDraft>>(
      context: context,
      builder: (_) => SetBuilderDialog(exerciseName: exercise.name),
    );
    if (sets == null || sets.isEmpty) return;

    final exDraft = draft.ExerciseDraft(
      exerciseId: exercise.id,
      exerciseName: exercise.name,
      sets: sets,
    );

    _addExercise(exDraft);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Nombre del workout'),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _openExerciseFlow,
            icon: const Icon(Icons.fitness_center),
            label: const Text('Añadir ejercicio'),
          ),
          const Divider(height: 32),
          if (_workout.exercises.isEmpty)
            const Text('Aún no has añadido ejercicios.'),
          ..._workout.exercises.map(
            (e) => ListTile(
              title: Text(e.exerciseName),
              subtitle: Text(
                '${e.sets.length} sets • ${e.sets.map((s) => s.reps).join('/')} reps',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
