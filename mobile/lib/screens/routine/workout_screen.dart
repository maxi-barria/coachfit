import 'package:flutter/material.dart';
import 'package:mobile/models/set_workout.dart';
import 'package:mobile/models/workout.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/widgets/routine/workout_exercise_widget.dart';

class WorkoutScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutScreen({
    required this.workout, 
    super.key
  });

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  int elapsedSeconds = 0;
  late DateTime startTime;
  
  @override
  void initState() {
    super.initState();
    startTime = DateTime.now();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          elapsedSeconds = DateTime.now().difference(startTime).inSeconds;
        });
        _startTimer();
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _finishWorkout() {
    // Actualizar la duración del workout
    widget.workout.secondsDuration = elapsedSeconds;
    // Aquí puedes agregar la lógica para guardar en la base de datos
    Navigator.pop(context);
  }

  void _toggleSetCompletion(String setId) {
    // Aquí implementarías la lógica para marcar/desmarcar un set como completado
    // Podrías usar un campo adicional en Set o mantener el estado localmente
    setState(() {
      // Lógica para cambiar el estado del set
    });
  }

  void _addSet(String workoutExerciseId) {
    // Lógica para agregar una nueva serie al ejercicio
    final newSet = SetWorkout(
      id: '', // Se generará en el backend
      workoutExerciseId: workoutExerciseId,
      repetition: 0,
      weight: 0.0,
      restSeconds: 60,
      createdAt: DateTime.now(),
    );
    
    setState(() {
      // Agregar el set a la lista correspondiente
      final workoutExercise = widget.workout.workoutExercises
          .firstWhere((we) => we.id == workoutExerciseId);
      workoutExercise.sets.add(newSet);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.workout.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _formatTime(elapsedSeconds),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              onPressed: _finishWorkout,
              child: const Text(
                "Finalizar",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: MyTheme.backgroundColor,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.workout.workoutExercises.length,
        itemBuilder: (context, index) {
          final workoutExercise = widget.workout.workoutExercises[index];
          return WorkoutExerciseWidget(
            workoutExercise: workoutExercise,
            onSetCompleted: _toggleSetCompletion,
            onAddSet: () => _addSet(workoutExercise.id),
          );
        },
      ),
    );
  }
}