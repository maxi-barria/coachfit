import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/env/environment.dart';
import 'package:mobile/utils/date_formatter.dart';
import 'package:mobile/providers/loggin_provider.dart';

class WorkoutSessionService {
  final String _baseUrl = Environment.apiUrl;

  Future<List<Map<String, dynamic>>> fetchSessionHistory(LogginProvider auth) async {
    final url = Uri.parse('$_baseUrl/workout-sessions');
    final headers = auth.getAuthHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Error al obtener el historial de sesiones');
    }

    final List data = json.decode(response.body);
    return data.map<Map<String, dynamic>>((session) {
      final sets = session['setSessions'] ?? [];

      // Agrupar sets por nombre de ejercicio
      final Map<String, List<Map<String, dynamic>>> grouped = {};
      for (final s in sets) {
        final name = s['workoutExercise']?['exercise']?['name'] ?? 'Ejercicio desconocido';
        grouped.putIfAbsent(name, () => []).add(s);
      }

      final exercises = <String>[];
      final bestSets = <String>[];
      final setCounts = <int>[];
      final List<Map<String, dynamic>> setData = [];

      for (final entry in grouped.entries) {
        final name = entry.key;
        final setsForExercise = entry.value;

        if (setsForExercise.isEmpty) continue;

        final topSet = setsForExercise.reduce(
          (a, b) => (a['weight'] * a['rep']) > (b['weight'] * b['rep']) ? a : b,
        );

        exercises.add(name);
        bestSets.add('${topSet['weight']} kg x ${topSet['rep']}');
        setCounts.add(setsForExercise.length);

        for (final s in setsForExercise) {
          final weight = s['weight'] ?? 0;
          final reps = s['rep'] ?? 0;
          final oneRM = (weight * (1 + reps / 30)).round();

          setData.add({
            'exercise': name,
            'weight': weight,
            'rep': reps,
            '1RM': oneRM,
          });
        }
      }

      return {
        'id': session['id'],
        'date': formatRelativeDate(session['startedAt']),
        'workout': session['workout']?['name'] ?? 'Sesión',
        'summary': session['summary'] ?? {
          'totalSets': sets.length,
          'totalReps': 0,
          'totalVolume': 0,
        },
        'exercises': exercises,
        'bestSets': bestSets,
        'setCounts': setCounts,
        'prs': 0,
        'setData': setData,
      };
    }).toList();
  }
}
