import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../env/environment.dart';

class CoachInvitationService {
  final String baseUrl = Environment.apiUrl;

  Future<void> sendInvitation({
    required String coachId,
    required String email,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/coach-invitations');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'coachId': coachId,
        'emailClient': email,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('No se pudo enviar la invitación');
    }
  }
}
