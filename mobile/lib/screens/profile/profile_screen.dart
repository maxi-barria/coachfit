import 'package:flutter/material.dart';
import 'package:mobile/services/workout/workout_session_service.dart';
import 'package:mobile/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:mobile/providers/loggin_provider.dart';
import 'package:mobile/widgets/workout_history_card.dart';
import 'package:mobile/themes/themes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;
  List<dynamic> sessions = [];

  @override
  void initState() {
    super.initState();
    loadSessions();
  }

  Future<void> loadSessions() async {
    final auth = Provider.of<LogginProvider>(context, listen: false);
    final data = await WorkoutSessionService().fetchSessionHistory(auth);
    setState(() {
      sessions = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.secondary,
      appBar: CustomAppBar(
        title: 'Perfil',
        showBack: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Cerrar sesión'),
                      content: const Text(
                        '¿Estás seguro de que quieres cerrar sesión?',
                      ),
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
                await Provider.of<LogginProvider>(
                  context,
                  listen: false,
                ).logout();
                Navigator.pushReplacementNamed(context, 'login');
              }
            },
          ),
        ],
      ),

      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : sessions.isEmpty
              ? const Center(
                child: Text(
                  "No hay historial",
                  style: TextStyle(color: Colors.white),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final s = sessions[index];
                  return WorkoutHistoryCard(
                    title: s['workout'],
                    exercises: List<String>.from(s['exercises']),
                    bestSets: List<String>.from(s['bestSets']),
                    date: s['date'],
                    totalSets: (s['summary']['totalSets'] ?? 0) as int,
                    prs: s['prs'],
                    setCounts: List<int>.from(s['setCounts']),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        'workout_detail',
                        arguments: s,
                      );
                    },
                    onActionSelected: (action) {
                      // TODO
                    },
                  );
                },
              ),
    );
  }
}
