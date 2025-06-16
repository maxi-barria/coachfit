import 'package:flutter/material.dart';
import 'package:mobile/models/set_workout.dart';
import 'package:mobile/themes/themes.dart';

class SetRow extends StatelessWidget {
  final int setNumber;
  final SetWorkout set;
  final bool isCompleted;
  final VoidCallback onCompleted;
  final Function(double) onWeightChanged;
  final Function(int) onRepsChanged;

  const SetRow({
    required this.setNumber,
    required this.set,
    required this.isCompleted,
    required this.onCompleted,
    required this.onWeightChanged,
    required this.onRepsChanged,
    super.key,
  });

  // Función para obtener el RIR basado en el intensityIndicator
  String _getRirText() {
    if (set.intensityIndicator != null) {
      // Asumiendo que el intensityIndicator tiene un campo 'value' o similar
      return set.intensityIndicator!.name ?? "0";
    }
    return "0";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Información anterior (placeholder - podrías obtener datos de sesiones anteriores)
          Expanded(
            flex: 2,
            child: Text(
              "${set.weight.toInt()}x${set.repetition} R${_getRirText()}",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          
          // Peso
          Expanded(
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                color: MyTheme.primary.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                initialValue: set.weight.toString(),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                onChanged: (value) {
                  final weight = double.tryParse(value) ?? 0.0;
                  onWeightChanged(weight);
                },
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Reps
          Expanded(
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                color: MyTheme.primary.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                initialValue: set.repetition.toString(),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                onChanged: (value) {
                  final reps = int.tryParse(value) ?? 0;
                  onRepsChanged(reps);
                },
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // RIR (basado en intensityIndicator)
          Expanded(
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                color: MyTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  _getRirText(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Checkbox
          GestureDetector(
            onTap: onCompleted,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? MyTheme.primary : Colors.transparent,
                border: Border.all(
                  color: isCompleted ? MyTheme.primary : Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isCompleted
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}