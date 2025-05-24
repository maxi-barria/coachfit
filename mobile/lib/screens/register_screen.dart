import '../services/auth/register_service.dart';
import 'package:mobile/core/core.dart';


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
    Navigator.pushReplacementNamed(context, '/login');
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
      appBar: const CustomAppBar(title: 'Registrarse'),
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
              Button(text: 'Registrarse', onPressed: _register, height: 48,)
            ],
          ),
        ),
      ),
    );
  }
}
