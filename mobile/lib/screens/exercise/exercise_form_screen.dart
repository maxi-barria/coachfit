import 'package:flutter/material.dart';
import '../../services/exercise/exercise_service.dart';
import '../../core/core.dart'; // Asegúrate de que aquí está CustomAppBar
import '../../themes/themes.dart'; // Importa tu tema

class ExerciseFormScreen extends StatefulWidget {
  final Map<String, dynamic>? existingExercise;

  const ExerciseFormScreen({super.key, this.existingExercise});

  @override
  State<ExerciseFormScreen> createState() => _ExerciseFormScreenState();
}

class _ExerciseFormScreenState extends State<ExerciseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  bool get isEditing => widget.existingExercise != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.existingExercise?['name'] ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.existingExercise?['description'] ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim(),
    };

    try {
      final service = ExerciseService();
      Map<String, dynamic>? result;

      if (isEditing) {
        result = await service.updateExercise(
          widget.existingExercise!['id'],
          data,
        );
      } else {
        result = await service.createExercise(data);
      }

      if (mounted) {
        Navigator.of(context).pop(result); // Devuelve el nuevo/actualizado
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = theme.colorScheme.surface;

    return Scaffold(
      appBar: CustomAppBar(
        title: isEditing ? 'Editar Ejercicio' : 'Nuevo Ejercicio',
        showBack: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  filled: true,
                  fillColor: surfaceColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  filled: true,
                  fillColor: surfaceColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isEditing ? 'Guardar cambios' : 'Crear ejercicio',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
