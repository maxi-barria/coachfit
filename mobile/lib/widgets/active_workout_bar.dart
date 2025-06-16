// lib/widgets/active_workout_bar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/providers/workout_status_provider.dart';
import 'package:mobile/themes/themes.dart';

class ActiveWorkoutBar extends StatelessWidget {
  const ActiveWorkoutBar({super.key, required this.onTap});
  final VoidCallback onTap;

  String _fmt(int v) => v.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final ws        = context.watch<WorkoutStatusProvider>();
    final workout   = ws.activeWorkout!;
    final mins      = _fmt(ws.elapsedSecs ~/ 60);
    final secs      = _fmt(ws.elapsedSecs % 60);
    final timerTxt  = '$mins:$secs';

    return GestureDetector(
      onTap: ws.isMinimized ? onTap : null,
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(14),
        color: MyTheme.primary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  ws.isMinimized ? 'Workout en curso' : workout.name,
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(timerTxt,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              Icon(ws.isMinimized ? Icons.expand_less : Icons.expand_more,
                  color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
