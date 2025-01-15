import 'package:flutter/material.dart';

class PlayerWonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vitória'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Você venceu!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Voltar ao início ou reiniciar o jogo
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Voltar ao início'),
            ),
          ],
        ),
      ),
    );
  }
}