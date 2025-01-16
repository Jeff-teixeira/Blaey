import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'package:lottie/lottie.dart'; // Opcional para animações

// Importações corrigidas
import 'package:blaey_app/pages/waiting_for_player_page.dart'; // Substitua pelo caminho correto
import 'package:blaey_app/pages/waiting_direto.dart'; // Substitua pelo caminho correto

class FloatingGameOptions extends StatelessWidget {
  final String gameTitle;
  final String gameImagePath;

  FloatingGameOptions({required this.gameTitle, required this.gameImagePath});

  final AudioPlayer _audioPlayer = AudioPlayer();

  void _playSound(String sound) async {
    await _audioPlayer.play(AssetSource(sound)); // Usando AssetSource
  }

  void _vibrate() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 50); // Vibração curta
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 5,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Nome do jogo (maior, mais grosso e em maiúsculo)
            Text(
              gameTitle.toUpperCase(), // Convertido para maiúsculo
              style: TextStyle(
                fontSize: 34, // Tamanho maior
                fontWeight: FontWeight.w900, // Fonte mais grossa (Black)
                color: Colors.black,
              ),
            ),
            SizedBox(height: 6),

            // Imagem do jogo
            Image.asset(
              gameImagePath,
              width: 170,
              height: 170,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),

            // Texto explicativo (frase desafiadora)
            Text(
              'Escolha seu modo e domine meu desafio!', // Frase alterada
              style: TextStyle(
                fontSize: 16, // Tamanho um pouco maior
                color: Colors.black54,
                fontWeight: FontWeight.bold, // Texto em negrito
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Botão "Negociada"
            AnimatedButton(
              text: 'Negociada',
              color: Colors.black, // Preto sólido
              icon: Icons.handshake,
              onPressed: () {
                print('Botão "Negociada" clicado'); // Log para depuração
                _playSound('click.mp3');
                _vibrate();
                Navigator.pop(context); // Fecha o diálogo
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      print('Navegando para WaitingForPlayerPage'); // Log para depuração
                      return WaitingForPlayerPage(gameTitle: gameTitle);
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 12),

            // Botão "Direto"
            AnimatedButton(
              text: 'Direto',
              color: Colors.black, // Preto sólido
              icon: Icons.play_arrow,
              onPressed: () {
                _playSound('click.mp3');
                _vibrate();
                Navigator.pop(context); // Fecha o diálogo
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WaitingDiretoPage(gameTitle: gameTitle), // Navega para WaitingDiretoPage
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final String text;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  AnimatedButton({
    required this.text,
    required this.color,
    required this.icon,
    required this.onPressed,
  });

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTapDown: (_) => _controller.forward(),
          onTapUp: (_) {
            _controller.reverse();
            widget.onPressed();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: widget.color, // Cor preta sólida
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  // Inner Shadow
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF878787).withOpacity(0.44), // Cor #878787 com 44% de opacidade
                            blurRadius: 11,
                            spreadRadius: 0,
                            offset: Offset(-11, -14), // x: -11, y: -14
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Botão
                  ElevatedButton(
                    onPressed: null, // Desabilitamos o onPressed padrão
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Fundo transparente
                      shadowColor: Colors.transparent, // Sem sombra
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Colors.white.withOpacity(0.2), // Borda sutil
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(widget.icon, color: Colors.white, size: 28), // Ícone à esquerda
                        SizedBox(width: 12),
                        Expanded(
                          child: Center(
                            child: Text(
                              widget.text,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // Texto branco
                              ),
                              textAlign: TextAlign.center, // Texto centralizado
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}