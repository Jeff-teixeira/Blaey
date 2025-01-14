import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart' as auth; // Use alias for auth_service
import '../pages/login_page.dart'; // Importação corrigida

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sair da conta'),
            onTap: () async {
              // Usar o AuthService para fazer logout
              final authService = Provider.of<auth.AuthService>(context, listen: false);
              await authService.signOut();

              // Navegar para a página de login
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
          // Adicione mais opções de configuração aqui, se necessário
        ],
      ),
    );
  }
}