import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/env/environment.dart';
import 'package:mobile/models/exercise.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseService {
  final String baseUrl = Environment.apiUrl;

  Future<List<Exercise>> getExercises() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/exercises'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Exercise.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  Future<Exercise> getExerciseById(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/exercises/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Exercise.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load exercise');
    }
  }

  Future<List<Map<String, dynamic>>> getExerciseHistory(
    String exerciseId,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/progress/exercise/$exerciseId/history'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      throw Exception('Error al obtener el historial del ejercicio');
    }
  }

  Future<List<List<Map<String, dynamic>>>> getGroupedExerciseHistory(
    String exerciseId,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/progress/exercise/$exerciseId/history/grouped'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data
          .map(
            (group) =>
                (group as List<dynamic>)
                    .map((e) => Map<String, dynamic>.from(e))
                    .toList(),
          )
          .toList();
    } else {
      throw Exception('Error al obtener historial agrupado del ejercicio');
    }
  }

  Future<Map<String, dynamic>?> getExercisePR(String exerciseId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/progress/exercise/$exerciseId/pr'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 404) {
      return null; // Sin PR registrado
    } else {
      throw Exception('Error al obtener el PR del ejercicio');
    }
  }
}
