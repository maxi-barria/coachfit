import 'package:flutter/material.dart';
import 'package:mobile/core/core.dart';   // CustomAppBar
import 'package:mobile/themes/themes.dart';
import 'package:provider/provider.dart';
import 'package:mobile/providers/routine_provider.dart';
import 'package:mobile/models/routine.dart'; // Importa Routine

class RoutineFormScreen extends StatefulWidget {
  const RoutineFormScreen({super.key});

  @override
  State<RoutineFormScreen> createState() => _RoutineFormScreenState();
}

class _RoutineFormScreenState extends State<RoutineFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _goalCtrl = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  /* ---------------- helpers ---------------- */
  Future<void> _pickDate({
    required DateTime? initial,
    required ValueChanged<DateTime> onSelected,
  }) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
      initialDate: initial ?? now,
      helpText: 'Selecciona fecha',
      locale: const Locale('es'),
    );
    if (picked != null) onSelected(picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final onlyOneDate =
        (_startDate != null && _endDate == null) ||
        (_startDate == null && _endDate != null);

    if (onlyOneDate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa ambas fechas o deja ambas vacías')),
      );
      return;
    }

    final payload = {
      'name': _nameCtrl.text.trim(),
      if (_goalCtrl.text.trim().isNotEmpty) 'goal': _goalCtrl.text.trim(),
      if (_startDate != null) 'startDate': _startDate!.toIso8601String(),
      if (_endDate != null) 'endDate': _endDate!.toIso8601String(),
      'workouts': <Map<String, dynamic>>[],
    };

    final routineProvider = context.read<RoutineProvider>();
    final Routine? created = await routineProvider.createRoutine(payload);

    if (created != null && mounted) {
      Navigator.pushReplacementNamed(
        context,
        'routine_wizard',
        arguments: created.id,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al crear rutina')),
      );
    }
  }

  /* ------------------ UI ------------------ */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Nueva rutina'),
      backgroundColor: MyTheme.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Nombre *'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Obligatorio' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _goalCtrl,
                decoration: const InputDecoration(labelText: 'Objetivo (opcional)'),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.date_range),
                      label: Text(
                        _startDate == null
                            ? 'Fecha inicio'
                            : _startDate!.toLocal().toString().split(' ')[0],
                      ),
                      onPressed: () => _pickDate(
                        initial: _startDate,
                        onSelected: (d) => setState(() => _startDate = d),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.date_range),
                      label: Text(
                        _endDate == null
                            ? 'Fecha fin'
                            : _endDate!.toLocal().toString().split(' ')[0],
                      ),
                      onPressed: () => _pickDate(
                        initial: _endDate,
                        onSelected: (d) => setState(() => _endDate = d),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: _submit,
                child: const Text('Crear rutina'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _goalCtrl.dispose();
    super.dispose();
  }
}
