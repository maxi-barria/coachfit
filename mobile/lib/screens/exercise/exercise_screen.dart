import 'package:flutter/material.dart';
import 'package:mobile/models/exercise.dart';
import 'package:mobile/services/exercise/exercise_service.dart';
import 'package:mobile/widgets/ejercicios/exercise_item.dart';
import '../../core/core.dart'; // incluye CustomAppBar y temas

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  String searchQuery = "";
  List<Exercise> allExercises = [];
  final ExerciseService _exerciseService = ExerciseService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    setState(() => isLoading = true);

    try {
      final response = await _exerciseService.getExercises();
      final List<Exercise> all =
          response.map((e) => Exercise.fromJson(e)).toList();

      final userId =
          all
              .firstWhere(
                (e) => e.userId != null,
                orElse:
                    () => Exercise(
                      id: '',
                      name: '',
                      description: '',
                      type: '',
                      secondsDuration: 0,
                      imageUrl: '',
                      gifUrl: '',
                      userId: '',
                      isCustom: false,
                    ),
              )
              .userId;

      final List<Exercise> userExercises =
          all.where((e) => e.userId == userId).toList();
      final Set<String> userCustomNames =
          userExercises.map((e) => e.name.toLowerCase()).toSet();

      final List<Exercise> globalExercises =
          all
              .where(
                (e) =>
                    e.userId == null &&
                    !userCustomNames.contains(e.name.toLowerCase()),
              )
              .toList();

      setState(() {
        allExercises = [...userExercises, ...globalExercises];
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      throw Exception('Error al cargar los ejercicios: $e');
    }
  }

  Future<void> _confirmDelete(String id, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Eliminar ejercicio'),
            content: Text('¿Seguro que quieres eliminar "$name"?'),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.pop(context, false),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Eliminar'),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
    );

    if (confirm == true) {
      try {
        await _exerciseService.deleteExercise(id);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Ejercicio eliminado')));
        _loadExercises();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredExercises =
        allExercises
            .where((ex) => ex.name.toLowerCase().contains(searchQuery))
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));

    final theme = Theme.of(context);
    final bgColor = theme.scaffoldBackgroundColor;
    final surfaceColor = theme.colorScheme.surface;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: const CustomAppBar(title: 'Ejercicios', showBack: false),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (value) {
                setState(() => searchQuery = value.toLowerCase());
              },
              decoration: InputDecoration(
                hintText: 'Buscar Ejercicio',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    final created = await Navigator.pushNamed(
                      context,
                      'exercise_form',
                    );
                    if (created == true)
                      _loadExercises(); // recargar lista si se creó
                  },
                ),
                filled: true,
                fillColor: surfaceColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: theme.textTheme.bodyMedium, // usa texto del tema
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      itemCount: filteredExercises.length,
                      itemBuilder: (context, index) {
                        final exercise = filteredExercises[index];
                        return ExerciseItem(
                          id: exercise.id,
                          gifUrl: exercise.gifUrl,
                          name: exercise.name,
                          muscleGroup: exercise.type,
                          isCustom: exercise.isCustom,
                          onEdit: () async {
                            final updated = await Navigator.pushNamed(
                              context,
                              'exercise_form',
                              arguments: exercise.toJson(), // <--- CAMBIO AQUÍ
                            );
                            if (updated != null) {
                              await _loadExercises();

                              // Mostrar un mensaje según si se trató de una edición o una clonación
                              if (updated is Map<String, dynamic>) {
                                final updatedId = updated['id'];
                                if (updatedId != exercise.id) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Ejercicio clonado y editado',
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Ejercicio actualizado'),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          onDelete:
                              () => _confirmDelete(exercise.id, exercise.name),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
