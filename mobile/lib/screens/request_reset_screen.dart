import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestResetScreen extends StatefulWidget {
  const RequestResetScreen({super.key});

  @override
  State<RequestResetScreen> createState() => _RequestResetScreenState();
}

class _RequestResetScreenState extends State<RequestResetScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _message;

  Future<void> _sendResetLink() async {
    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      setState(() {
        _message = 'Ingresa un correo válido.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/auth/request-reset'), // localhost para emulador
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);

      setState(() {
        _message = data['message'] ?? 'Solicitud enviada.';
      });
    } catch (e) {
      setState(() {
        _message = 'Error al enviar el correo.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Ingresa tu correo y te enviaremos un enlace para restablecer tu contraseña.'),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _sendResetLink,
                    child: const Text('Enviar enlace'),
                  ),
            if (_message != null) ...[
              const SizedBox(height: 20),
              Text(
                _message!,
                style: TextStyle(
                  color: _message!.contains('Error') ? Colors.red : Colors.green,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
