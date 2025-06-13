import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/env/environment.dart';
import 'package:mobile/models/exercise.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseService {
  final String baseUrl = Environment.apiUrl;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<Map<String, dynamic>>> getExercises() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/exercises'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al obtener ejercicios');
    }
  }

  Future<Map<String, dynamic>> createExercise(Map<String, dynamic> data) async {
  final token = await _getToken();

  final response = await http.post(
    Uri.parse('$baseUrl/exercises'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: json.encode(data),
  );

  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception('Error al crear ejercicio');
  }

  return Map<String, dynamic>.from(json.decode(response.body));
}


Future<Map<String, dynamic>> updateExercise(String id, Map<String, dynamic> data) async {
  final token = await _getToken();

  final response = await http.put(
    Uri.parse('$baseUrl/exercises/$id'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: json.encode(data),
  );



  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception('Error al actualizar ejercicio');
  }

  final body = json.decode(response.body);


  final status = body['status'];

  if (status != 200 && status != 201) {
    throw Exception('Error al actualizar ejercicio (status interno)');
  }

  return body.containsKey('data')
      ? Map<String, dynamic>.from(body['data'])
      : {
          'id': id,
          ...data,
        };
}




  Future<void> deleteExercise(String id) async {
    final token = await _getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/exercises/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar ejercicio');
    }
  }

  Future<Map<String, dynamic>> getExerciseById(String id) async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/exercises/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      throw Exception('Ejercicio no encontrado');
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
