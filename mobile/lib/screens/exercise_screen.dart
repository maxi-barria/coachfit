import 'package:flutter/material.dart';
//import 'package:coach_fit/widgets/ejercicios/exercise_item.dart';
import 'package:mobile/widgets/core/navigation.dart';
import 'package:mobile/widgets/ejercicios/exercise_item.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});
  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  String searchQuery = "";
  final List<ExerciseWidget> allExercises =[];

  @override
  Widget build(BuildContext context) {
    final filteredExercises = allExercises
      .where((ex) => ex.name.toLowerCase().contains(searchQuery))
      .toList()
    ..sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: Navigation(),
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
            child: TextField(
              onChanged: (value) {
                setState(() => searchQuery = value.toLowerCase());
              },
              decoration: InputDecoration(
                hintText: 'Buscar Ejercicio',
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.filter_list),
                filled: true,
                fillColor: Colors.deepOrange[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: filteredExercises.length,
            itemBuilder: (context, index) {
              final exercise = filteredExercises[index];
              return ExerciseWidget(
                gifUrl: exercise.gifUrl,
                name: exercise.name,
                muscleGroup: exercise.muscleGroup,
              );
            },
          ),
        ),
        ],
      ),
    );
  }
}
