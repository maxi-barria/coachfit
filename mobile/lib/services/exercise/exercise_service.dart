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
        'Authorization': 'Bearer $token'
      }  
    );


    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      print(response.body);
      return jsonList.map((json) => Exercise.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  Future<Exercise> getExerciseById(String id) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/exercises/$id'),
      headers: {
        'Authorization': 'Bearer $token'
      }
    );

    if (response.statusCode == 200) {
      return Exercise.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load exercise');}
  }

}