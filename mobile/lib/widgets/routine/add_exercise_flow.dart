/* =========================================================================
 *  widgets/add_exercise_flow.dart
 *  (botón flotante, builder de sets y selector de ejercicios)
 * ========================================================================= */

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:mobile/core/core.dart';          // CustomAppBar
import 'package:mobile/env/environment.dart';
import 'package:mobile/models/exercise.dart';
import 'package:mobile/providers/loggin_provider.dart';
import 'package:mobile/providers/routine_provider.dart';
import 'package:mobile/services/exercise/exercise_service.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/models/draft.dart'; // usa el modelo central

class AddExerciseButton extends StatelessWidget {
  const AddExerciseButton({required this.workoutId, super.key});
  final String workoutId;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: MyTheme.primary,
      onPressed: () => _openExerciseFlow(context),
      child: const Icon(Icons.fitness_center),
    );
  }

  Future<void> _openExerciseFlow(BuildContext context) async {
    final exercise = await Navigator.push<Exercise?>(
      context,
      MaterialPageRoute(builder: (_) => const ExercisePickerScreen()),
    );
    if (exercise == null) return;

    final sets = await showDialog<List<SetDraft>>(
      context: context,
      builder: (_) => SetBuilderDialog(exerciseName: exercise.name),
    );
    if (sets == null || sets.isEmpty) return;

    final payload = {
      'exerciseId': exercise.id,
      'sets': sets.map((s) => s.toJson()).toList(),
    };

    final ok = await context
        .read<RoutineProvider>()
        .addExerciseToWorkout(workoutId, payload);

    if (ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ejercicio agregado')),
      );
    }
  }
}

class SetBuilderDialog extends StatefulWidget {
  const SetBuilderDialog({required this.exerciseName, super.key});
  final String exerciseName;

  @override
  State<SetBuilderDialog> createState() => _SetBuilderDialogState();
}

class _SetBuilderDialogState extends State<SetBuilderDialog> {
  final List<SetDraft> _sets = [SetDraft()];

  final List<String> rirOptions = ['6', '7', '8', '9', '10'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Sets – ${widget.exerciseName}'),
      content: SizedBox(
        width: 320,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _sets.length,
          itemBuilder: (_, i) => _setRow(i),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => setState(() => _sets.add(SetDraft())),
          child: const Text('+ Set'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _sets),
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  Widget _setRow(int i) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          _numField(
              initial: _sets[i].reps,
              label: 'Reps',
              onChanged: (v) => _sets[i].reps = v),
          const SizedBox(width: 4),
          _numField(
              initial: _sets[i].weight,
              label: 'Kg',
              onChanged: (v) => _sets[i].weight = v.toDouble()),
          const SizedBox(width: 4),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _sets[i].intensityIndicatorId,
              decoration: const InputDecoration(labelText: 'RIR'),
              items: rirOptions
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (val) => setState(() {
                _sets[i].intensityIndicatorId = val;
              }),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 18),
            onPressed: _sets.length == 1
                ? null
                : () => setState(() => _sets.removeAt(i)),
          ),
        ],
      ),
    );
  }

  Widget _numField({
    required num initial,
    required String label,
    required ValueChanged<int> onChanged,
  }) {
    return Expanded(
      child: TextFormField(
        initialValue: initial.toString(),
        textAlign: TextAlign.center,
        decoration: InputDecoration(labelText: label),
        keyboardType: TextInputType.number,
        onChanged: (v) => onChanged(int.tryParse(v) ?? 0),
      ),
    );
  }
}

class ExercisePickerScreen extends StatefulWidget {
  const ExercisePickerScreen({super.key});

  @override
  State<ExercisePickerScreen> createState() => _ExercisePickerScreenState();
}

class _ExercisePickerScreenState extends State<ExercisePickerScreen> {
  final ExerciseService _exerciseService = ExerciseService();

  List<Exercise> _all = [];
  List<Exercise> _filtered = [];

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    setState(() => _loading = true);

    try {
      final auth = context.read<LogginProvider>();
      final userId = auth.currentUser?.id;

      final response = await _exerciseService.getExercises();
      final all =
          response.map((e) => Exercise.fromJson(e)).toList();

      final userExercises = all.where((e) => e.userId == userId).toList();
      final userNames =
          userExercises.map((e) => e.name.toLowerCase()).toSet();

      final globalExercises = all
          .where((e) =>
              e.userId == null &&
              !userNames.contains(e.name.toLowerCase()))
          .toList();

      _all = [...userExercises, ...globalExercises]
        ..sort((a, b) => a.name.compareTo(b.name));
      _filtered = _all;
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Elegir ejercicio'),
      backgroundColor: MyTheme.backgroundColor,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Buscar ejercicio',
                        ),
                        onChanged: (txt) => setState(() {
                          _filtered = _all
                              .where((e) => e.name
                                  .toLowerCase()
                                  .contains(txt.toLowerCase()))
                              .toList();
                        }),
                      ),
                    ),
                    Expanded(
                      child: _filtered.isEmpty
                          ? const Center(child: Text('Sin resultados'))
                          : ListView.separated(
                              itemCount: _filtered.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (_, i) => ListTile(
                                title: Text(_filtered[i].name),
                                onTap: () => Navigator.pop(context, _filtered[i]),
                              ),
                            ),
                    ),
                  ],
                ),
    );
  }
}
