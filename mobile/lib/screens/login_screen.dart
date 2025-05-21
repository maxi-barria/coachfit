import 'package:mobile/themes/themes.dart';
import 'package:mobile/widgets/core/button.dart';
import 'package:mobile/widgets/login/login_form_field.dart';
import 'package:flutter/material.dart';
import '../services/auth/auth_service.dart';
import 'package:mobile/screens/primary_screen.dart';

final AuthService _authService = AuthService();
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
  if (_formKey.currentState!.validate()) {
    try {
      final result = await _authService.login(
        _emailController.text,
        _passwordController.text,
      );
            print('✅ Redirigiendo a primary');
      // Mostrar token o redirigir
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sesión iniciada: ${result['token']}')),
      );

    Future.delayed(Duration(milliseconds: 100), () {
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const PrimaryScreen()),
  );
  });


    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(29, 31, 36, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(29, 31, 36, 1),
        elevation: 0,
        leading: Row(
          children: [
            TextButton.icon(
              label: Text(
                'Atrás',
                style: TextStyle(color: MyTheme.primary, fontSize: 16),
              ),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: MyTheme.primary,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ]),
        title: Text('Iniciar Sesión',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LoginFormField(
                controller: _emailController,
                label: 'Correo',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu correo';
                  }
                  if (!value.contains('@')) {
                    return 'Correo inválido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              LoginFormField(
                controller: _passwordController,
                label: 'Contraseña',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 8) {
                    return 'Mínimo 8 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              Button(text: 'Iniciar Sesión', onPressed: _login, height: 32,)
            ],
          ),
        ),
      ),
    );
  }
}
