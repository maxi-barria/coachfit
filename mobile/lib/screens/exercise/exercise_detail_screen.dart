import 'package:flutter/material.dart';
import 'package:mobile/models/exercise.dart';
import 'package:mobile/services/exercise/exercise_service.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/widgets/ejercicios/tab_item.dart';
import 'grafic.dart';
import 'historial.dart';
import 'rp.dart';
import '../../core/core.dart'; // Asegúrate de importar donde esté CustomAppBar

class ExerciseDetailScreen extends StatefulWidget {
  final String id;
  const ExerciseDetailScreen({required this.id, super.key});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen>
    with TickerProviderStateMixin {
  final ExerciseService exerciseService = ExerciseService();
  late final String id = widget.id;
  Exercise? _exercise;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExercise();
  }

  Future<void> _loadExercise() async {
    setState(() => _isLoading = true);
    try {
      final json = await exerciseService.getExerciseById(id);
      setState(() {
        _exercise = Exercise.fromJson(json);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar ejercicio: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.scaffoldBackgroundColor;
    final surfaceColor = theme.colorScheme.surface;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: CustomAppBar(
          title: _isLoading ? '' : _exercise?.name ?? 'Ejercicio',
          showBack: true,
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator(color: MyTheme.primary))
            : _exercise == null
                ? const Center(child: Text('No se encontró el ejercicio.'))
                : Column(
                    children: [
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            color: surfaceColor,
                          ),
                          child: const TabBar(
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: Colors.transparent,
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Color.fromRGBO(255, 61, 0, 0.2),
                            ),
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.black,
                            tabs: [
                              TabItem(title: 'Detalle'),
                              TabItem(title: 'Historial'),
                              TabItem(title: 'Gráfico'),
                              TabItem(title: 'Rp'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: TabBarView(
                          children: [
                            SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!_exercise!.isCustom)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      margin: const EdgeInsets.only(bottom: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.orange[100],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text('Ejercicio global', style: TextStyle(fontSize: 12)),
                                    ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: _exercise!.gifUrl != null && _exercise!.gifUrl.toString().isNotEmpty
                                        ? Image.network(
                                            _exercise!.gifUrl,
                                            fit: BoxFit.contain,
                                            errorBuilder: (_, __, ___) => Container(
                                              height: 200,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.broken_image, size: 40),
                                            ),
                                          )
                                        : Container(
                                            height: 200,
                                            color: Colors.grey[300],
                                            child: const Center(
                                              child: Icon(Icons.image_not_supported, size: 40),
                                            ),
                                          ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _exercise!.description,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            ExerciseHistoryTab(exerciseId: _exercise!.id),
                            ExerciseProgressChart(exerciseId: _exercise!.id),
                            ExercisePRTab(exerciseId: _exercise!.id),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
