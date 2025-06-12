import 'package:mobile/providers/loggin_provider.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/widgets/core/button.dart';
import 'package:mobile/widgets/login/login_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/screens/login/primary_screen.dart';
import '../../widgets/custom_app_bar.dart';

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
        final result = await context.read<LogginProvider>().login(
          _emailController.text,
          _passwordController.text,
        );
        if (!result) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error al iniciar sesión.')));
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sesión iniciada correctamente.')),
        );

        Navigator.pushReplacementNamed(
          context,
          'main'
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(29, 31, 36, 1),
      appBar: const CustomAppBar(title: 'Iniciar Sesión'),
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
              const SizedBox(height: 16),
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
              const SizedBox(height: 24),
              Button(text: 'Iniciar Sesión', onPressed: _login, height: 48),

              // Nuevo botón para recuperación de contraseña
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'request-reset');
                  },
                  child: Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(
                      color: MyTheme.primary,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
