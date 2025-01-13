import 'package:flutter/material.dart';
import 'waiting_for_player_page.dart';
import 'waiting_direto.dart';

class FloatingDialog extends StatelessWidget {
  final String gameTitle;

  FloatingDialog({required this.gameTitle});

  @override
  Widget build(BuildContext context) {
    // Determina o caminho da imagem baseado no título do jogo
    String gameImagePath;
    switch (gameTitle.toLowerCase()) {
      case 'dama':
        gameImagePath = 'assets/jogos/dama.png';
        break;
      case 'xadrez':
        gameImagePath = 'assets/jogos/xadrez.png';
        break;
      case 'ludo':
        gameImagePath = 'assets/jogos/ludo.png';
        break;
      case 'truco':
        gameImagePath = 'assets/jogos/truco.png';
        break;
      case 'jogo da velha':
        gameImagePath = 'assets/jogos/jogo_da_velha.png';
        break;
      default:
        gameImagePath = 'assets/jogos/default.png';
        break;
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Modo de Jogo:',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            SizedBox(height: 20),
            Image.asset(gameImagePath, width: 160, height: 160), // Exibe a imagem do jogo correspondente
            SizedBox(height: 20),
            // Usando Row para colocar os botões na mesma linha
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Espalha os botões igualmente
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WaitingForPlayerPage(gameTitle: gameTitle)),
                    );
                  },
                  icon: Icon(Icons.attach_money, color: Colors.black), // Ícone preto
                  label: Text(
                    'Negociada',
                    style: TextStyle(fontSize: 18, color: Colors.black), // Texto preto
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow, // Cor de fundo amarela
                    padding: EdgeInsets.symmetric(vertical: 20), // Aumenta o botão verticalmente
                    minimumSize: Size(200, 60), // Aumenta a largura do botão
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(width: 10), // Espaço entre os botões
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WaitingDiretoPage(gameTitle: gameTitle)),
                    );
                  },
                  icon: Icon(Icons.flash_on, color: Colors.white), // Ícone branco
                  label: Text(
                    'Direto',
                    style: TextStyle(fontSize: 18, color: Colors.white), // Texto branco
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Cor de fundo preta
                    padding: EdgeInsets.symmetric(vertical: 20), // Aumenta o botão verticalmente
                    minimumSize: Size(200, 60), // Aumenta a largura do botão
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
