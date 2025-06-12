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
            List<dynamic> jsonList = json.decode(response.body);
            print(response.body);
            return jsonList.map((json) => Routine.fromJson(json)).toList();
        } else {
            throw Exception('Failed to load routines');
        }

    }

}