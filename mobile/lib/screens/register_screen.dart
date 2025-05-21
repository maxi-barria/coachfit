import 'package:mobile/themes/themes.dart';
import 'package:mobile/widgets/core/button.dart';
import 'package:mobile/widgets/login/login_form_field.dart';
import 'package:flutter/material.dart';
import '../services/auth/register_service.dart';


final RegisterService _registerService = RegisterService();
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

 void _register() async {
  if (_formKey.currentState!.validate()) {
    try {
      final result = await _registerService.register(
        _emailController.text,
        _passwordController.text,
        _confirmPasswordController.text,
      );

      if (result['success'] == true) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(result['message'])), // ← Mensaje del backend
  );

  // Opcional: redirige al login
  Future.delayed(Duration(seconds: 1), () {
    Navigator.pushReplacementNamed(context, 'login');
  });

} else {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('${result['message']}')),
  );
}

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error inesperado: $e')),
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
        title: Text('Registrarse',
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
              SizedBox(height: 16),
              LoginFormField(
                controller: _confirmPasswordController,
                label: 'Confirmar Contraseña',
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              Button(text: 'Registrarse', onPressed: _register, height: 32,)
            ],
          ),
        ),
      ),
    );
  }
}
