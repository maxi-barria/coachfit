import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../env/environment.dart';
import 'package:mobile/models/coach_client.dart';

class CoachClientService {
  final String baseUrl = Environment.apiUrl;

  Future<List<CoachClient>> getClients(String coachId, String token) async {
    final url = Uri.parse('$baseUrl/coach-clients/$coachId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CoachClient.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener clientes: ${response.body}');
    }
  }
  Future<void> deleteClient(String clientId, String token) async {
  final url = Uri.parse('$baseUrl/coach-clients/$clientId');
  final response = await http.delete(url, headers: {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  });

  if (response.statusCode != 204) {
    throw Exception('Error al eliminar cliente');
  }
}

}
