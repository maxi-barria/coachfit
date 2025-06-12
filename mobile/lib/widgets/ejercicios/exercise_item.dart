import 'package:flutter/material.dart';

class ExerciseItem extends StatelessWidget {
  final String? id;
  final String? name;
  final String? gifUrl;
  final String? muscleGroup;

  const ExerciseItem({
    required this.id,
    required this.name,
    required this.gifUrl,
    required this.muscleGroup,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Navigator.of(context, rootNavigator: true).pushNamed('exercise_detail', arguments: id),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                gifUrl ?? '',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 40,
                    height: 40,
                    color: Colors.red[200],
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name ?? '',
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
                Text(
                  muscleGroup ?? '',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
