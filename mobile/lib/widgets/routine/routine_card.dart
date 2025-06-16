import 'package:flutter/material.dart';
import 'package:mobile/models/routine.dart';
import 'package:mobile/themes/themes.dart';

class RoutineCard extends StatelessWidget {
  final Routine routine;
  const RoutineCard({
    required this.routine,
    super.key
  });
  
  @override
  Widget build(BuildContext context) {
     return GestureDetector(
      onTap:
          () => Navigator.pushNamed(context, 'workout', arguments: routine ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  routine.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Icon(Icons.add, color: MyTheme.primary),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'DETALLE EJERCICIOS',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.red, size: 16),
                SizedBox(width: 4),
                Text(routine.startDate.toString()),
              ],
            ),
          ],
        ),
      )
    );
  }
}