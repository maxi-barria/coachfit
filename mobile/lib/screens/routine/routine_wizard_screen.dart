import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/core/core.dart';
import 'package:mobile/models/draft.dart';
import 'package:mobile/models/routine.dart';
import 'package:mobile/providers/routine_provider.dart';
import 'package:mobile/screens/routine/workout_builder.dart';
import 'package:mobile/widgets/routine/routine_preview.dart';
import 'package:provider/provider.dart';

class RoutineWizardScreen extends StatefulWidget {
  final Routine? routine;

  const RoutineWizardScreen({super.key, this.routine});

  @override
  State<RoutineWizardScreen> createState() => _RoutineWizardScreenState();
}

class _RoutineWizardScreenState extends State<RoutineWizardScreen> {
  int _step = 0;
  final _basicForm = GlobalKey<FormState>();

  late RoutineDraft _draft;

  @override
  void initState() {
    super.initState();
    final r = widget.routine;

    if (r != null) {
      _draft = RoutineDraft(
        name: r.name,
        goal: r.goal,
        start: r.startDate,
        end: r.endDate,
        workouts: r.routineWorkouts?.map((rw) {
              return WorkoutDraft(
                name: rw.workout?.name ?? '',
                date: rw.workout?.date ?? DateTime.now(),
                exercises: [],
              );
            }).toList() ??
            [],
      );
    } else {
      _draft = RoutineDraft(name: '', goal: '', workouts: []);
    }
  }

  void _next() {
    if (_step == 0 && !_basicForm.currentState!.validate()) return;
    if (_step == 1 && _draft.workouts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega al menos un workout')),
      );
      return;
    }
    setState(() => _step += 1);
  }

  void _back() => setState(() => _step -= 1);

  Future<void> _save() async {
    final provider = context.read<RoutineProvider>();

    // ✅ Inspección visual del JSON que se enviará
    final payload = _draft.toJson();
    debugPrint('Payload enviado: ${jsonEncode(payload)}');

    final Routine? created = await provider.createRoutine(payload);

    if (mounted && created != null) {
      if (created.workouts.isNotEmpty) {
        Navigator.pushReplacementNamed(
          context,
          'workout',
          arguments: created.workouts.first,
        );
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rutina creada sin workouts')),
        );
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error al crear rutina')));
    }
  }

  void _addWorkout() async {
    WorkoutDraft? result;
    final builderKey = GlobalKey<WorkoutBuilderState>();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        content: SizedBox(
          width: double.maxFinite,
          child: WorkoutBuilder(key: builderKey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              final workout = builderKey.currentState?.workout;
              if (workout == null || workout.exercises.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Agrega al menos un ejercicio')),
                );
                return;
              }
              result = workout;
              await Future.delayed(const Duration(milliseconds: 100));
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Guardar workout'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() => _draft.workouts.add(result!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Nueva rutina'),
      body: Stepper(
        currentStep: _step,
        onStepContinue: _step < 2 ? _next : _save,
        onStepCancel: _step > 0 ? _back : null,
        controlsBuilder: (context, details) => Row(
          children: [
            FilledButton(
              onPressed: details.onStepContinue,
              child: Text(_step < 2 ? 'Siguiente' : 'Guardar'),
            ),
            const SizedBox(width: 8),
            if (_step > 0)
              OutlinedButton(
                onPressed: details.onStepCancel,
                child: const Text('Atrás'),
              ),
          ],
        ),
        steps: [
          Step(
            title: const Text('Datos básicos'),
            content: Form(
              key: _basicForm,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _draft.name,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Requerido' : null,
                    onSaved: (v) => _draft.name = v!,
                    onChanged: (v) => _draft.name = v,
                  ),
                  TextFormField(
                    initialValue: _draft.goal,
                    decoration: const InputDecoration(labelText: 'Objetivo'),
                    onChanged: (v) => _draft.goal = v,
                  ),
                ],
              ),
            ),
          ),
          Step(
            title: const Text('Ejercicios & sets'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FilledButton.icon(
                  onPressed: _addWorkout,
                  icon: const Icon(Icons.add),
                  label: const Text('Añadir workout'),
                ),
                const SizedBox(height: 12),
                if (_draft.workouts.isEmpty)
                  const Text('Aún no has añadido ningún workout.'),
                ..._draft.workouts.map(
                  (w) => ListTile(
                    title: Text(w.name),
                    subtitle: Text(
                      '${w.exercises.fold(0, (sum, e) => sum + e.sets.length)} sets',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Revisar'),
            content: RoutinePreview(draft: _draft),
          ),
        ],
      ),
    );
  }
}
