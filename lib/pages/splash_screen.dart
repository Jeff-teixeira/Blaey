import 'package:flutter/material.dart';
import 'dart:async';
import 'chat/messages_page.dart'; // Importe a tela de mensagens

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Configuração da animação
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    // Navegar para a tela de mensagens após 2 segundos
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MessagesPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF18e138), // Fundo verde #18e138
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Image.asset(
            'assets/icons/icon_transparente.png',
            width: 550,
            height: 550,
          ),
        ),
      ),
    );
  }
}