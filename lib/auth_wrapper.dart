import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Adicione esta linha
import 'services/auth_service.dart';
import 'pages/login_page.dart';
import 'main.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(  // Alterado para User?
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          return user == null ? LoginPage() : HomePage();
        }
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}