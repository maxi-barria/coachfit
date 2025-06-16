import 'package:flutter/material.dart';

class ExerciseItem extends StatelessWidget {
  final String id;
  final String name;
  final String? gifUrl;
  final String muscleGroup;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isCustom;

  const ExerciseItem({
    super.key,
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.isCustom,
    this.gifUrl,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
          rootNavigator: true,
        ).pushNamed('exercise_detail', arguments: id);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:
                  gifUrl != null && gifUrl!.isNotEmpty
                      ? Image.network(
                        gifUrl!,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Container(
                              width: 40,
                              height: 40,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, size: 20),
                            ),
                      )
                      : Container(
                        width: 40,
                        height: 40,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, size: 20),
                      ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(
                    muscleGroup,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit?.call();
                } else if (value == 'delete') {
                  onDelete?.call();
                }
              },
              itemBuilder: (_) {
                final items = <PopupMenuEntry<String>>[
                  const PopupMenuItem(value: 'edit', child: Text('Editar')),
                ];

                if (isCustom) {
                  items.add(
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Eliminar'),
                    ),
                  );
                }

                return items;
              },
            ),
          ],
        ),
      ),
    );
  }
}
