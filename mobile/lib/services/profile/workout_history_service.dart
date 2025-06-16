import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/env/environment.dart';
import 'package:mobile/models/workout_history_entry.dart';

class WorkoutHistoryService {
  final String baseUrl = Environment.apiUrl;

  Future<List<WorkoutHistoryEntry>> getHistory(String token) async {
    final now = DateTime.now();
    final past = now.subtract(const Duration(days: 90)); // últimos 90 días

    final url = Uri.parse(
        '$baseUrl/workout-sessions/summary?from=${past.toIso8601String()}&to=${now.toIso8601String()}');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((item) => WorkoutHistoryEntry.fromJson(item))
          .toList();
    } else {
      throw Exception('Error al cargar historial (${response.statusCode})');
    }
  }
}
