import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterService {
  static const String baseUrl = 'https://coachfit-backend.onrender.com'; // ← para Android emulator

  Future<Map<String, dynamic>> register(
      String email, String password, String confirmPassword) async {
    final url = Uri.parse('$baseUrl/auth/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        }),
      );

      final data = jsonDecode(response.body);
      return {
        'success': data['success'] == true,
        'message': data['message'],
        'token': data['token'],
        'user': data['user'],
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión con el servidor',
      };
    }
  }
}
