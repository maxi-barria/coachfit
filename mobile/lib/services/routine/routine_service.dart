import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/env/environment.dart';
import 'package:mobile/models/routine.dart';

import 'package:shared_preferences/shared_preferences.dart';


class RoutineService {
    final String baseUrl = Environment.apiUrl;
    
    Future<List<Routine>> getRoutines() async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? token = prefs.getString('token');

        final response = await http.get(
            Uri.parse('$baseUrl/routines'),
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token'
            }

        );

        if (response.statusCode == 200) {
            List<dynamic> decodedData = jsonDecode(response.body);
            return decodedData.map((json) => Routine.fromJson(json)).toList(); 
        } else {
            throw Exception('Failed to load routines');
        }
    }

    Future<Routine> getRoutineById(String id) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? token = prefs.getString('token');

        final response = await http.get(
            Uri.parse('$baseUrl/routines/$id'),
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token'
            }
        );

        if (response.statusCode == 200) {
            return Routine.fromJson(json.decode(response.body));
        } else {
            throw Exception('Failed to load routine');
        }
    }

    Future<Routine> createRoutine(Routine routine) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? token = prefs.getString('token');

        final response = await http.post(
            Uri.parse('$baseUrl/routines'),
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token'
            },
            body: json.encode(routine.toJson())
        );

        if (response.statusCode == 201) {
            return Routine.fromJson(json.decode(response.body));
        } else {
            throw Exception('Failed to create routine');
        }
    }

    Future<Routine> updateRoutine(String id, Map<String, dynamic> data) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? token = prefs.getString('token');

        final response = await http.put(
            Uri.parse('$baseUrl/routines/$id'),
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token'
            },
            body: json.encode(data)
        );

        if (response.statusCode == 200) {
            return Routine.fromJson(json.decode(response.body));
        } else {
            throw Exception('Failed to update routine');
        }
    }

    Future<void> deleteRoutine(String id) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? token = prefs.getString('token');

        final response = await http.delete(
            Uri.parse('$baseUrl/routines/$id'),
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token'
            }
        );

        if (response.statusCode != 200) {
            throw Exception('Failed to delete routine');
        }
    }
}