import 'package:flutter/material.dart';

class ExerciseWidget extends StatelessWidget {
  final String gifUrl;
  final String name;
  final String muscleGroup;

  const ExerciseWidget({
    super.key,
    required this.gifUrl,
    required this.name,
    required this.muscleGroup,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              gifUrl,
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
                name,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              Text(
                muscleGroup,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
