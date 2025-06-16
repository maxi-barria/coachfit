import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/exercise/exercise_service.dart';

class ExerciseProgressChart extends StatefulWidget {
  final String exerciseId;
  const ExerciseProgressChart({Key? key, required this.exerciseId}) : super(key: key);

  @override
  State<ExerciseProgressChart> createState() => _ExerciseProgressChartState();
}

class _ExerciseProgressChartState extends State<ExerciseProgressChart> {
  late Future<List<Map<String, dynamic>>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = ExerciseService().getExerciseHistory(widget.exerciseId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _historyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay datos disponibles'));
        }

        final data = snapshot.data!;
        final Map<String, double> volumeByDate = {};

        for (final d in data) {
          final dateStr = DateTime.parse(d['date']).toIso8601String().split('T').first;
          final weight = (d['weight'] as num).toDouble();
          final reps = (d['reps'] as num).toDouble();
          final volume = weight * reps;

          volumeByDate.update(dateStr, (existing) => existing + volume, ifAbsent: () => volume);
        }

        if (volumeByDate.isEmpty) {
          return const Center(child: Text('No hay datos para graficar.'));
        }

        final sortedDates = volumeByDate.keys.toList()..sort();
        final spots = <FlSpot>[];
        final labels = <String>[];

        for (int i = 0; i < sortedDates.length; i++) {
          final date = sortedDates[i];
          final volume = volumeByDate[date]!;
          spots.add(FlSpot(i.toDouble(), volume));
          final parsedDate = DateTime.parse(date);
          labels.add('${parsedDate.day}/${parsedDate.month}');
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Volumen total por sesión (Peso × Reps)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: LineChart(
                  LineChartData(
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        axisNameWidget: const Text('Sesión'),
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            final i = value.toInt();
                            return i >= 0 && i < labels.length
                                ? Text(labels[i], style: const TextStyle(fontSize: 10))
                                : const Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        axisNameWidget: const Text('Volumen (kg × reps)'),
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          getTitlesWidget: (value, _) => Text(
                            value.toStringAsFixed(0),
                            style: const TextStyle(fontSize: 10),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: Colors.teal,
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const LegendItem(color: Colors.teal, label: 'Volumen total por sesión'),
            ],
          ),
        );
      },
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const LegendItem({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 14, height: 14, color: color),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}
