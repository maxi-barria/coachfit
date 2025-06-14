import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/providers/loggin_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(29, 31, 36, 1),
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: const Color.fromRGBO(29, 31, 36, 1),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Cerrar sesión'),
                  content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
                  actions: [
                    TextButton(
                      child: const Text('Cancelar'),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    TextButton(
                      child: const Text('Cerrar sesión'),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
                ),
              );

              if (shouldLogout == true) {
                await Provider.of<LogginProvider>(context, listen: false).logout();
                Navigator.pushReplacementNamed(context, 'login');
              }
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Bienvenido a tu perfil',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
