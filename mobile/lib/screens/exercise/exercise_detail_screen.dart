import 'package:flutter/material.dart';
import 'package:mobile/models/exercise.dart';
import 'package:mobile/services/exercise/exercise_service.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/widgets/ejercicios/tab_item.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final String id;
  const ExerciseDetailScreen({required this.id, super.key});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> with TickerProviderStateMixin{
  @override
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
      //print('Error loading exercise: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
Widget build(BuildContext context) {
  return DefaultTabController(
    length: 4,
    child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _isLoading ? '' : _exercise.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: MyTheme.primary))
          : Column(
              children: [
                const SizedBox(height: 8),
                // Mover TabBar aquí
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey[200],
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
                        TabItem(title: 'Rp')
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Aquí puedes poner contenido diferente por tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            ClipRRect(
                              child: Image(
                                image: NetworkImage(_exercise.gifUrl ?? ''),
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _exercise.description,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Center(child: Text('Historial')),
                      Center(child: Text('Gráfico')),
                      Center(child: Text('Rp')),
                    ],
                  ),
                )
              ],
            ),
    ),
  );
}

}
