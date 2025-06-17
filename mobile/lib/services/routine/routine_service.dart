import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/env/environment.dart';
import 'package:mobile/models/routine.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoutineService {
  final String baseUrl = Environment.apiUrl;

  /* ---------------------- helpers ---------------------- */
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Map<String, String> _headers(String? token) => {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  Routine _handleResponse(http.Response res) {
    final status = res.statusCode;
    if (status == 200 || status == 201) {
      return Routine.fromJson(jsonDecode(res.body));
    }
    throw Exception('Error $status: ${res.body}');
  }

  /* --------------------- RUTINAS ----------------------- */
  Future<List<Routine>> getRoutines() async {
    final res = await http.get(
      Uri.parse('$baseUrl/routines'),
      headers: _headers(await _getToken()),
    );

    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List)
          .map((e) => Routine.fromJson(e))
          .toList();
    }
    throw Exception('Error ${res.statusCode}: ${res.body}');
  }

  Future<Routine> getRoutineById(String id) async {
    final res = await http.get(
      Uri.parse('$baseUrl/routines/$id'),
      headers: _headers(await _getToken()),
    );
    return _handleResponse(res);
  }

  Future<Routine> createRoutine(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/routines'),
      headers: _headers(await _getToken()),
      body: jsonEncode(data),
    );
    return _handleResponse(res);
  }

  Future<Routine> updateRoutine(String id, Map<String, dynamic> data) async {
    final res = await http.put(
      Uri.parse('$baseUrl/routines/$id'),
      headers: _headers(await _getToken()),
      body: jsonEncode(data),
    );
    return _handleResponse(res);
  }

  Future<void> deleteRoutine(String id) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/routines/$id'),
      headers: _headers(await _getToken()),
    );

    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Error ${res.statusCode}: ${res.body}');
    }
  }

  /* ----------- NUEVO: agregar ejercicio a workout ----------- */
  Future<void> addExerciseToWorkout(
    String workoutId,
    Map<String, dynamic> payload,
  ) async {
    final res = await http.post(
      Uri.parse('$baseUrl/workouts/$workoutId/exercises'),
      headers: _headers(await _getToken()),
      body: jsonEncode(payload),
    );

    if (res.statusCode != 201) {
      throw Exception('Error ${res.statusCode}: ${res.body}');
    }
  }
}
