import 'package:flutter/material.dart';
import 'package:mobile/models/coach_client.dart';
import 'package:mobile/services/coach/coach_client_service.dart';
import 'package:mobile/services/coach/coach_invitation_service.dart';
import 'package:mobile/themes/themes.dart';
import '../../widgets/coach/coach_client_item.dart';

class CoachScreen extends StatefulWidget {
  final String coachId;
  final String token;

  const CoachScreen({super.key, required this.coachId, required this.token});

  @override
  State<CoachScreen> createState() => _CoachScreenState();
}

class _CoachScreenState extends State<CoachScreen> {
  final CoachClientService _service = CoachClientService();
  List<CoachClient> clients = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    try {
      final data = await _service.getClients(widget.coachId, widget.token);
      setState(() {
        clients = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error: $e');
      setState(() => isLoading = false);
    }
  }
  void _showInviteDialog() {
  final TextEditingController emailController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: MyTheme.darkSurf,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Invitar cliente', style: TextStyle(color: Colors.white)),
      content: TextField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          labelText: 'Correo del cliente',
          labelStyle: TextStyle(color: Colors.white),
        ),
        style: const TextStyle(color: Colors.white),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            final email = emailController.text.trim();
            if (email.isEmpty || !email.contains('@')) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Correo no válido')),
              );
              return;
            }

            Navigator.pop(context);
            try {
              await CoachInvitationService().sendInvitation(
                coachId: widget.coachId,
                email: email,
                token: widget.token,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invitación enviada')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${e.toString()}')),
              );
            }
          },
          child: const Text('Enviar'),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.darkBg,
      appBar: AppBar(
        backgroundColor: MyTheme.darkBg,
        foregroundColor: Colors.white,
        title: const Text("Mis clientes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt),
            onPressed: () {
              _showInviteDialog();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : clients.isEmpty
              ? const Center(child: Text("Sin clientes aún", style: TextStyle(color: Colors.white)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: clients.length,
                  itemBuilder: (_, index) {
                    return CoachClientItem(client: clients[index]);
                  },
                ),
    );
  }
}
