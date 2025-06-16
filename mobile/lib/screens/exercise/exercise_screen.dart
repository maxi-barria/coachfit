import 'package:flutter/material.dart';
import 'package:mobile/models/exercise.dart';
import 'package:mobile/services/exercise/exercise_service.dart';
import 'package:mobile/widgets/ejercicios/exercise_item.dart';

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
      final exercises = await _exerciseService.getExercises();
      setState(() {
        allExercises = exercises;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      throw Exception('Error al cargar los ejercicios: $e');
    }
    print('Ejercicios cargados: ${allExercises}');
  }

  @override
  Widget build(BuildContext context) {
    final filteredExercises = allExercises
        .where((ex) => ex.name.toLowerCase().contains(searchQuery))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        title: Text(
          'Ejercicios',
          style: TextStyle(
            fontSize: 28,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() => searchQuery = value.toLowerCase());
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar Ejercicio',
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.deepOrange[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                Icon(Icons.filter_list),
                Icon(Icons.add)
              ],
            )
          ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: filteredExercises.length,
            itemBuilder: (context, index) {
              final exercise = filteredExercises[index];
              return ExerciseItem(
                id: exercise.id,
                gifUrl: exercise.gifUrl,
                name: exercise.name,
                muscleGroup: exercise.type,
              );
            },
          ),
        ),
        ],
      ),
    );
  }
}
