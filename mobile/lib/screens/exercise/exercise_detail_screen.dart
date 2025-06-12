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
  late Exercise _exercise;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExercise();
  }

  Future<void> _loadExercise() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final exercise = await exerciseService.getExerciseById(id);
      setState(() {
        _exercise = exercise;
      });
    } catch (e) {

    } finally {
      setState(() {
        _isLoading = false;
      });
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
          title: _isLoading ? '' : _exercise.name,
          showBack: true,
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(color: MyTheme.primary),
              )
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
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image(
                                  image: NetworkImage(_exercise.gifUrl ?? ''),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _exercise.description,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        ExerciseHistoryTab(exerciseId: _exercise.id),
                        ExerciseProgressChart(exerciseId: _exercise.id),
                        ExercisePRTab(exerciseId: _exercise.id),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
