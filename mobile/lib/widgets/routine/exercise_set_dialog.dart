import 'package:flutter/material.dart';
import 'package:mobile/models/draft.dart';

class ExerciseSetDialog extends StatefulWidget {
  final String exerciseId;
  final String exerciseName;
  const ExerciseSetDialog({
    super.key,
    required this.exerciseId,
    required this.exerciseName,
  });

  @override
  State<ExerciseSetDialog> createState() => _ExerciseSetDialogState();
}

class _ExerciseSetDialogState extends State<ExerciseSetDialog> {
  final _sets = <SetDraft>[SetDraft()];
  final List<String> rirOptions = ['6', '7', '8', '9', '10'];

  void _addSet() => setState(() => _sets.add(SetDraft()));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(widget.exerciseName, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ..._sets.asMap().entries.map((entry) {
            final i = entry.key;
            final s = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Reps', isDense: true),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => s.reps = int.tryParse(v) ?? 0,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Peso (kg)', isDense: true),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (v) => s.weight = double.tryParse(v) ?? 0,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: s.intensityIndicatorId,
                    decoration: const InputDecoration(labelText: 'RIR', isDense: true),
                    items: rirOptions
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                        .toList(),
                    onChanged: (val) => setState(() => s.intensityIndicatorId = val),
                  ),
                ),
              ]),
            );
          }),
          OutlinedButton.icon(
            onPressed: _addSet,
            icon: const Icon(Icons.add),
            label: const Text('Añadir set'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              Navigator.pop(
                context,
                ExerciseDraft(
                  exerciseId: widget.exerciseId,
                  exerciseName: widget.exerciseName,
                  sets: _sets,
                ),
              );
            },
            child: const Text('Guardar ejercicio'),
          )
        ]),
      ),
    );
  }
}
