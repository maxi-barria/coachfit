/* =========================================================================
 *  screens/exercise/exercise_picker_screen.dart
 *  Reutiliza ExerciseService – sin CRUD, sin botones de edición/borrado.
 * ========================================================================= */

import 'package:flutter/material.dart';
import 'package:mobile/models/exercise.dart';
import 'package:mobile/services/exercise/exercise_service.dart';
import 'package:mobile/providers/loggin_provider.dart';
import 'package:provider/provider.dart';

import 'package:mobile/core/core.dart';   // CustomAppBar
import 'package:mobile/themes/themes.dart';

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
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  /* ----------- carga igual que en ExerciseScreen ----------- */
  Future<void> _loadExercises() async {
    setState(() => _loading = true);
    try {
      final auth = context.read<LogginProvider>();
      final userId = auth.currentUser?.id;

      final response = await _exerciseService.getExercises();
      final List<Exercise> all =
          response.map((e) => Exercise.fromJson(e)).toList();

      final userExercises = all.where((e) => e.userId == userId).toList();
      final userCustomNames =
          userExercises.map((e) => e.name.toLowerCase()).toSet();

      final globalExercises = all
          .where((e) =>
              e.userId == null &&
              !userCustomNames.contains(e.name.toLowerCase()))
          .toList();

      _all = [...userExercises, ...globalExercises]..sort((a, b) => a.name.compareTo(b.name));
      _filtered = _all;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar ejercicios: $e')),
      );
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
                      searchQuery = txt.toLowerCase();
                      _filtered = _all
                          .where((e) =>
                              e.name.toLowerCase().contains(searchQuery))
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
                            subtitle: _filtered[i].type != null
                                ? Text(_filtered[i].type!)
                                : null,
                            onTap: () =>
                                Navigator.pop(context, _filtered[i]),
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}
