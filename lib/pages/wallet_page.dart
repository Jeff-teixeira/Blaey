import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart'; // Importe o SharedPreferences
import 'rewarded_ad_page.dart';
import 'bonus_page.dart';
import 'store_page.dart';
import 'package:audioplayers/audioplayers.dart';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with TickerProviderStateMixin {
  double userBalance = 0.0;
  int currentLevel = 1;
  int adsWatched = 0;
  Timer? levelTimer;
  Timer? checkpointTimer;
  Timer? regressionTimer;
  bool isWatchingAd = false;
  bool isAtCheckpoint = false;
  bool showLevelText = false;
  bool showCoinAnimation = false;
  late AnimationController _progressController;
  late AnimationController _coinController;
  late AnimationController _balanceController;
  late AnimationController _flashController;
  late Animation<double> _progressAnimation;
  late Animation<Offset> _coinAnimation;
  late Animation<Color?> _balanceColorAnimation;
  late Animation<double> _flashAnimation;

  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioCache _audioCache = AudioCache(prefix: 'assets/som/');

  static const int level1Ads = 4;
  static const int level2Ads = 6;
  static const int level3Ads = 8;
  static const int checkpointDelaySeconds = 30;
  static const int regressionIntervalSeconds = 60;

  @override
  void initState() {
    super.initState();
    _loadUserBalance(); // Carregar o saldo salvo ao iniciar
    startLevelTimer();

    // Inicializa os controladores de animação
    _progressController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _coinController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _balanceController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _flashController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..repeat(reverse: true);

    // Inicializa as animações
    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(_progressController);
    _coinAnimation = Tween<Offset>(begin: Offset(0, 1), end: Offset(0, -2)).animate(_coinController);
    _balanceColorAnimation = ColorTween(begin: Colors.white, end: Colors.green)
        .animate(CurvedAnimation(parent: _balanceController, curve: Curves.easeInOut));
    _flashAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_flashController);

    // Pré-carregar sons
    _audioCache.loadAll(['move_sound.mp3', 'moeda.mp3']);
    startProgressRegression();
  }

  // Método para carregar o saldo salvo
  Future<void> _loadUserBalance() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userBalance = prefs.getDouble('userBalance') ?? 0.0; // Recupera o saldo ou define 0.0 como padrão
    });
  }

  // Método para salvar o saldo
  Future<void> _saveUserBalance(double balance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('userBalance', balance); // Salva o saldo
  }

  @override
  void dispose() {
    levelTimer?.cancel();
    checkpointTimer?.cancel();
    regressionTimer?.cancel();
    _progressController.dispose();
    _coinController.dispose();
    _balanceController.dispose();
    _flashController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void startLevelTimer() {
    levelTimer?.cancel();
    levelTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isWatchingAd && !isAtCheckpoint) {
        if (adsWatched > 0) {
          setState(() {
            isAtCheckpoint = true;
            checkpointTimer = Timer(Duration(seconds: checkpointDelaySeconds), () {
              regressionTimer = Timer.periodic(Duration(seconds: regressionIntervalSeconds), (timer) {
                if (!isWatchingAd && adsWatched > 0) {
                  setState(() {
                    adsWatched--;
                    _progressController.reverse(from: _progressController.value);
                  });
                } else {
                  regressionTimer?.cancel();
                }
              });
              isAtCheckpoint = false;
            });
          });
        } else if (currentLevel > 1) {
          setState(() {
            currentLevel--;
            adsWatched = currentLevel == 2 ? level1Ads : currentLevel == 3 ? level2Ads : level3Ads;
            _showLevelUpMessage("Nível $currentLevel");
          });
        }
      }
    });
  }

  void startProgressRegression() {
    regressionTimer?.cancel();
    regressionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isWatchingAd && !isAtCheckpoint && _progressController.value > 0) {
        setState(() {
          _progressController.value -= 1 / regressionIntervalSeconds;
        });
      }
    });
  }

  Future<void> _addReward(double reward) async {
    setState(() {
      userBalance += reward;
      _balanceController.forward().then((_) {
        _balanceController.reverse();
      });
    });

    await _saveUserBalance(userBalance); // Salva o saldo após adicionar a recompensa

    final player = AudioPlayer();
    await player.play(AssetSource('moeda.mp3'));
  }

  void _watchAd() async {
    isWatchingAd = true;
    final reward = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => RewardedAdPage(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
    isWatchingAd = false;

    if (reward != null) {
      setState(() {
        showCoinAnimation = true;

        if (currentLevel == 3 && adsWatched >= level3Ads) {
        } else {
          adsWatched++;
        }

        _progressController.forward(from: _progressController.value);
        _flashController.forward().then((_) {
          _flashController.reverse();
        });

        if (currentLevel == 1 && adsWatched >= level1Ads) {
          _showLevelUpMessage("Nível 2");
          currentLevel = 2;
          adsWatched = 0;
        } else if (currentLevel == 2 && adsWatched >= level2Ads) {
          _showLevelUpMessage("Nível 3");
          currentLevel = 3;
          adsWatched = 0;
        } else if (currentLevel == 3 && adsWatched >= level3Ads) {
          setState(() {
            adsWatched = level3Ads;
          });
        }

        _coinController.reset();
        _coinController.forward().then((_) {
          _addReward(currentLevel.toDouble());
          setState(() {
            showCoinAnimation = false;
          });
        });
      });
    }
  }

  void _showLevelUpMessage(String message) {
    setState(() {
      showLevelText = true;
    });

    Timer(Duration(seconds: 1), () {
      setState(() {
        showLevelText = false;
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: TextStyle(color: Colors.white, fontSize: 24)),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fundo preto para a carteira virtual
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFDAD9D9), // Rosa claro
              Color(0xBE1E1D1D), // Roxo médio
              Color(0xFF131212), // Roxo escuro
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 32), // Espaço acima do cartão virtual
              // Cartão Virtual
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30), // Aumentei o padding vertical
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)], // Verde escuro
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Cartão Virtual',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Icon(Icons.credit_card, color: Colors.white, size: 30),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Saldo disponível',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${userBalance.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Image.asset(
                          'assets/icons/logoblaey.png',
                          width: 70, // Aumentei o tamanho da imagem
                          height: 70,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32), // Espaço entre o cartão e os ícones
              _buildIconRow(),
              SizedBox(height: 32), // Espaço entre os ícones e o botão de anúncio
              Expanded(
                child: _buildRechargePoint(context),
              ),
              SizedBox(height: 16), // Espaço entre o bloco do anúncio e o botão
              // Banner de oferta para a loja
              Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF9800), Color(0xFFF44336)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.card_giftcard, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Compre moedas e ganhe +20% ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildIconButton(
          icon: Icons.mail_outline,
          label: 'Convite',
          color: Colors.white, // Ícone branco
          onTap: () {
            // Ação para Convite
          },
        ),
        _buildIconButton(
          icon: Icons.celebration, // Ícone de bônus mais bonito
          label: 'Bônus',
          color: Colors.white, // Ícone branco
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BonusPage()),
            );
          },
        ),
        _buildIconButton(
          icon: Icons.store,
          label: 'Loja',
          color: Colors.white, // Ícone branco
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StorePage(updateBalance: _addReward)),
            );
          },
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Icon(icon, size: 40, color: color),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRechargePoint(BuildContext context) {
    int totalAds = currentLevel == 1 ? level1Ads : currentLevel == 2 ? level2Ads : level3Ads;

    Color progressColor;
    switch (currentLevel) {
      case 1:
        progressColor = Colors.blueAccent;
        break;
      case 2:
        progressColor = Colors.redAccent;
        break;
      case 3:
        progressColor = Colors.purpleAccent;
        break;
      default:
        progressColor = Colors.blueAccent;
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Ganhe moedas agora!', // Centralizado
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: _watchAd,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: CircularProgressIndicator(
                        value: adsWatched / totalAds, // Atualiza a barra de progresso
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                        strokeWidth: 10,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Já define um círculo perfeito
                        gradient: LinearGradient(
                          colors: [Colors.greenAccent, Colors.yellowAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Bloco do 1,00
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Text(
                      '1,00',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent,
                      ),
                    ),
                    SizedBox(width: 8),
                    Image.asset(
                      'assets/icons/moeda.png', // Ícone de moeda
                      width: 20,
                      height: 20,
                    ),
                  ],
                ),
              ),
              // Bloco do L1 com círculo colorido
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Text(
                      'L$currentLevel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: progressColor, // Cor do nível
                        border: Border.all(
                          color: Colors.white, // Borda branca
                          width: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Bloco do 0/4
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.refresh, // Ícone de atualização
                      size: 20,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '$adsWatched/$totalAds',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}