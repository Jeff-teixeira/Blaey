import 'package:flutter/material.dart';
import 'dart:math';
import 'jogos/game_page_dama.dart';
import 'jogos/gamepage_chess.dart';
import 'jogos/gamepage_ludo.dart';
import 'jogos/gamepage_truco.dart';
import 'jogos/jogodavelha/gamepage_jogo_da_velha.dart';

class WaitingDiretoPage extends StatefulWidget {
  final String gameTitle;

  WaitingDiretoPage({required this.gameTitle});

  @override
  _WaitingDiretoPageState createState() => _WaitingDiretoPageState();
}

class _WaitingDiretoPageState extends State<WaitingDiretoPage> with TickerProviderStateMixin {
  late AnimationController _redPlayerController;
  late Animation<Offset> _redPlayerAnimation;
  late ScrollController _scrollController;
  late AnimationController _gameImageController;
  late Animation<double> _gameImageAnimation;

  bool _isFindingOpponent = true;
  final List<String> opponentImages = [
    'assets/users/oponente.png',
    'assets/users/oponente1.png',
    'assets/users/oponente2.png',
    'assets/users/oponente3.png',
    'assets/users/oponente4.png',
    'assets/users/oponente5.png',
    'assets/users/oponente6.png',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _redPlayerController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _redPlayerAnimation = Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0)).animate(CurvedAnimation(
      parent: _redPlayerController,
      curve: Curves.easeInOutBack,
    ));

    _gameImageController = AnimationController(
      duration: Duration(milliseconds: 6000),
      vsync: this,
    );

    _gameImageAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _gameImageController,
        curve: Curves.easeInOut,
      ),
    );

    _gameImageController.repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startWheelAnimation();
    });
  }

  @override
  void dispose() {
    _redPlayerController.dispose();
    _scrollController.dispose();
    _gameImageController.dispose();
    super.dispose();
  }

  void _startWheelAnimation() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 4),
      curve: Curves.linear,
    );

    Future.delayed(Duration(seconds: 4), () {
      setState(() {
        _isFindingOpponent = false;
      });

      _redPlayerController.forward();

      _startGame();
    });
  }

  void _startGame() {
    Widget gamePage;
    switch (widget.gameTitle.toLowerCase()) {
      case 'dama':
        gamePage = GamePageDama(betAmount: 2);
        break;
      case 'xadrez':
        gamePage = GamePageChess(betAmount: 2);
        break;
      case 'ludo':
        gamePage = GamePageLudo(betAmount: 2);
        break;
      case 'truco':
        gamePage = GamePageTruco(betAmount: 2);
        break;
      case 'jogo da velha':
        gamePage = GamePageJogoDaVelha(betAmount: 2);
        break;
      default:
        gamePage = GamePageDama(betAmount: 2);
        break;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => gamePage),
    );
  }

  @override
  Widget build(BuildContext context) {
    String gameImagePath;
    switch (widget.gameTitle.toLowerCase()) {
      case 'dama':
        gameImagePath = 'assets/jogos/damatab.png';
        break;
      case 'xadrez':
        gameImagePath = 'assets/jogos/chesstab.png';
        break;
      case 'ludo':
        gameImagePath = 'assets/jogos/chesstab.png';
        break;
      case 'truco':
        gameImagePath = 'assets/jogos/chesstab.png';
        break;
      case 'jogo da velha':
        gameImagePath = 'assets/jogos/chesstab.png';
        break;
      default:
        gameImagePath = 'assets/jogos/default.png';
        break;
    }

    return Scaffold(
      backgroundColor: Colors.black, // Fundo preto mais escuro
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.gameTitle,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold, // Negrito
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Text(
                  '2',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(width: 8),
                Image.asset(
                  'assets/icons/moeda.png',
                  width: 24,
                  height: 24,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 16.0),
                child: _buildOpponentSpinner(),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ScaleTransition(
                        scale: _gameImageAnimation,
                        child: Image.asset(
                          gameImagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading image: $error');
                            return Container(
                              color: Colors.grey,
                              child: Center(
                                child: Text(
                                  'Image not found',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 20),
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage('assets/icons/perfil.png'),
                          ),
                          SizedBox(width: 20),
                          if (!_isFindingOpponent)
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage(opponentImages[Random().nextInt(opponentImages.length)]),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_isFindingOpponent)
            Center(
              child: ScaleTransition(
                scale: _gameImageAnimation,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Buscando...',
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOpponentSpinner() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      height: 100,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: opponentImages.length * 100,
        itemBuilder: (context, index) {
          final image = opponentImages[index % opponentImages.length];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(image),
            ),
          );
        },
      ),
    );
  }
}
