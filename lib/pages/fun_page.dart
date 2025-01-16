import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_page.dart' as profile;
import 'trophies_page.dart';
import 'friend_profile_page.dart' as friendProfile;
import 'store_page.dart';
import 'blaey_page.dart';
import 'floating_game_options.dart'; // Importação corrigida

class FunPage extends StatefulWidget {
  final double userBalance;

  FunPage({required this.userBalance});

  @override
  _FunPageState createState() => _FunPageState();
}

class _FunPageState extends State<FunPage> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  String? _profileImagePath;
  late TabController _tabController;

  // Lista para rastrear o estado de cada botão de desafio
  List<bool> isChallenged = List.generate(5, (index) => false);

  @override
  void initState() {
    super.initState();
    _startTimer();
    _loadProfileImage();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileImagePath = prefs.getString('profile_image_path');
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Linha superior: Pesquisa, saldo, ranking, perfil e troféu
              _buildTopRow(),
              // Abas (Sala de Jogos e Vote)
              Container(
                padding: EdgeInsets.zero, // Remove o padding lateral
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.black, // Cor preto fosco
                  unselectedLabelColor: Colors.grey,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold, // Texto da aba selecionada em negrito
                    fontSize: 14.sp, // Tamanho menor
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.normal, // Texto da aba não selecionada normal
                  ),
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      width: 4.h, // Espessura da barrinha de seleção
                      color: Colors.blueGrey, // Cor da barrinha de seleção
                    ),
                    insets: EdgeInsets.symmetric(horizontal: 108.w), // Tamanho horizontal da barrinha
                  ),
                  tabs: [
                    Tab(text: 'Sala de Jogos'),
                    Tab(text: 'Vote'), // Texto alterado para "Vote"
                  ],
                ),
              ),
              // Conteúdo das abas
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Conteúdo da aba "Sala de Jogos" (página atual)
                    _buildMainContent(),
                    // Conteúdo da aba "Vote" (fundo azul claro)
                    Container(
                      color: Colors.blue[50], // Fundo azul claro
                      child: Center(
                        child: Text(
                          'Vote',
                          style: TextStyle(fontSize: 24, color: Colors.black),
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
    );
  }

  // Linha superior: Pesquisa, saldo, ranking, perfil e troféu
  Widget _buildTopRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Ícone de pesquisa
          InkWell(
            onTap: () {
              print("Ícone de pesquisa tocado");
            },
            child: Image.asset(
              'assets/images/pesquisa.png',
              width: 29.w,
              height: 30.h,
            ),
          ),
          // Saldo
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h), // Borda mais fechada
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20.r), // Borda mais arredondada
              border: Border.all(color: Colors.green, width: 1),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/moeda.png',
                  width: 24.w,
                  height: 24.h,
                ),
                SizedBox(width: 8.w),
                Text(
                  '\$${widget.userBalance.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                SizedBox(width: 8.w),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StorePage(updateBalance: (amount) {})),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Ranking, perfil e troféu
          Row(
            children: [
              InkWell(
                onTap: () {
                  print("Navegando para o ranking");
                },
                child: Icon(
                  Icons.bar_chart,
                  size: 30.sp,
                  color: Colors.black54,
                ),
              ),
              SizedBox(width: 8.w),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TrophiesPage()),
                  );
                },
                child: Icon(
                  Icons.emoji_events,
                  size: 30.sp,
                  color: Colors.amber,
                ),
              ),
              SizedBox(width: 8.w),
              InkWell(
                onTap: () {
                  print("Navegando para a página de perfil");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => profile.ProfilePage()),
                  );
                },
                child: CircleAvatar(
                  radius: 20.r,
                  backgroundColor: const Color(0xFFE7DFEC),
                  backgroundImage: _profileImagePath != null
                      ? FileImage(File(_profileImagePath!))
                      : AssetImage('assets/icons/perfil.png') as ImageProvider,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Conteúdo principal da página (Sala de Jogos)
  Widget _buildMainContent() {
    return ListView(
      padding: EdgeInsets.zero, // Remove o padding lateral
      children: [
        _buildBannerCarousel(),
        SizedBox(height: 12.h), // Espaço menor entre o banner e o carrossel
        _buildUserCarousel(),
        SizedBox(height: 13.h), // Espaço menor entre o carrossel e "Recentes"
        _buildRecentGames(),
        SizedBox(height: 20.h),
        _buildTournamentsAndEvents(),
        SizedBox(height: 10.h),
        _buildAllGamesGrid(),
        _buildAdAtBottom(),
      ],
    );
  }

  Widget _buildBannerCarousel() {
    return Container(
      height: 100.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0.r),
        child: PageView(
          controller: _pageController,
          onPageChanged: (int page) {
            setState(() {
              _currentPage = page;
            });
          },
          children: [
            Image.asset('assets/jogos/banner1.png', fit: BoxFit.cover),
            Image.asset('assets/jogos/banner2.png', fit: BoxFit.cover),
            Image.asset('assets/jogos/banner3.png', fit: BoxFit.cover),
            Image.asset('assets/jogos/banner4.png', fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCarousel() {
    return Column(
      children: [
        // Texto "Online" acima do carrossel
        Padding(
          padding: EdgeInsets.only(left: 300.w, bottom: 5.h), // Ajuste o padding conforme necessário
          child: Row(
            children: [
              Text(
                'Online',
                style: TextStyle(
                  fontSize: 10.sp, // Tamanho pequeno
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 4.w),
              Container(
                width: 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
        // Carrossel de usuários
        Container(
          height: 140.h, // Ajuste para evitar overflow
          padding: EdgeInsets.only(left: 10.w), // Carrossel mais à direita
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              String userName;
              String imagePath;
              Widget nextPage;

              if (index == 0) {
                userName = 'Blaey';
                imagePath = 'assets/icons/app_icon.png';
                nextPage = BlaeyPage();
              } else {
                userName = 'username';
                imagePath = 'assets/icons/user.png';
                nextPage = friendProfile.FriendProfilePage(userName);
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  children: [
                    // Bloco "Blaey" (sem "Online")
                    if (index == 0)
                      Container(
                        padding: EdgeInsets.all(12.w), // Espaçamento interno maior
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4), // Fundo branco 40% transparente
                          borderRadius: BorderRadius.circular(20.r), // Bordas mais arredondadas
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1), // Sombra discreta
                              blurRadius: 6.r,
                              offset: Offset(0, 3.h),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Círculo do usuário
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => nextPage,
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                radius: 28.r,
                                backgroundImage: AssetImage(imagePath),
                              ),
                            ),
                            SizedBox(height: 6.h), // Espaçamento menor
                            // Nome do usuário
                            Text(
                              userName,
                              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 6.h), // Espaçamento menor
                            // Botão "Web3.0" com estilo moderno e borda tecnológica
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isChallenged[index] = true;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isChallenged[index] ? Colors.grey[800] : Colors.blueGrey, // Cor preta
                                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h), // Botão mais largo
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.r), // Bordas arredondadas
                                  side: BorderSide(
                                    color: Colors.blueGrey, // Borda tecnológica
                                    width: 2.w,
                                  ),
                                ),
                              ),
                              child: Text(
                                isChallenged[index] ? 'Web3.0' : 'Web3.0', // Texto do botão
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Outros usuários (com "Online" apenas para "username")
                    if (index != 0)
                      Container(
                        padding: EdgeInsets.all(2.w), // Espaçamento menor
                        child: Column(
                          children: [
                            // Stack para o texto "Online" e o círculo do usuário
                            Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                // Círculo do usuário
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => nextPage,
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 28.r,
                                    backgroundImage: AssetImage(imagePath),
                                  ),
                                ),
                                // Texto "Online" (apenas para "username")
                                if (imagePath == 'assets/icons/user.png')
                                  Positioned(
                                    top: -10.h, // Ajuste a posição vertical do texto
                                    child: Text(
                                      'Online',
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 4.h), // Espaçamento menor
                            // Nome do usuário
                            Text(
                              userName,
                              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold), // Texto em negrito
                            ),
                            SizedBox(height: 4.h), // Espaçamento menor
                            // Botão "Desafiar" para outros usuários
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isChallenged[index] = true;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isChallenged[index] ? Colors.black : Colors.blue,
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: Text(
                                isChallenged[index] ? 'Desafiado' : 'Desafiar',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentGames() {
    return Padding(
      padding: EdgeInsets.only(left: 16.w), // Alinha à esquerda
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.timelapse,
                color: Colors.black,
              ),
              SizedBox(width: 6.w),
              Text(
                'Recentes',
                style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
          SizedBox(height: 7.h),
          Container(
            height: 145.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                final recentGames = [
                  {'image': 'assets/jogos/dama.png', 'name': 'Dama'},
                  {'image': 'assets/jogos/xadrez.png', 'name': 'Xadrez'},
                  {'image': 'assets/jogos/ludo.png', 'name': 'Ludo'},
                ];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return FloatingGameOptions(
                            gameTitle: recentGames[index]['name']!,
                            gameImagePath: recentGames[index]['image']!,
                          );
                        },
                      );
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          recentGames[index]['image']!,
                          width: 140.w,
                          height: 130.w,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          recentGames[index]['name']!,
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold), // Texto em negrito
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTournamentsAndEvents() {
    return Padding(
      padding: EdgeInsets.only(left: 16.w), // Alinha à esquerda
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.event,
                color: Colors.black,
              ),
              SizedBox(width: 8.w),
              Text(
                'Torneios e Eventos',
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Container(
            height: 180.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                final events = [
                  'assets/jogos/torneios.png',
                  'assets/jogos/eventos.png',
                  'assets/jogos/maratonas.png',
                ];
                return Container(
                  width: 240.w,
                  margin: EdgeInsets.only(right: 6.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9.r),
                    child: Image.asset(
                      events[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllGamesGrid() {
    return Padding(
      padding: EdgeInsets.only(left: 16.w), // Alinha à esquerda
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.all_inclusive, // Ícone de "All"
                color: Colors.black,
              ),
              SizedBox(width: 4.w),
              Text(
                'Todos os Jogos',
                style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          // Categorias de Jogos
          _buildGameCategory('Jogos VS', Icons.sports_esports, [
            {'name': 'Dama', 'image': 'assets/jogos/dama.png'},
            {'name': 'Xadrez', 'image': 'assets/jogos/xadrez.png'},
          ]),
          _buildGameCategory('Jogos em Grupo', Icons.group, [
            {'name': 'Ludo', 'image': 'assets/jogos/ludo.png'},
            {'name': 'Truco', 'image': 'assets/jogos/truco.png'},
          ]),
          _buildGameCategory('Jogos 2 vs 2', Icons.people, [
            {'name': 'Jogo da Velha', 'image': 'assets/jogos/jogo_da_velha.png'},
            {'name': 'Outro Jogo', 'image': 'assets/jogos/dama.png'},
          ]),
        ],
      ),
    );
  }

  Widget _buildGameCategory(String categoryName, IconData icon, List<Map<String, String>> games) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.w, top: 10.h),
          child: Row(
            children: [
              Icon(
                icon, // Ícone relacionado à categoria
                color: Colors.black,
              ),
              SizedBox(width: 4.w),
              Text(
                categoryName,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 18.w,
            mainAxisSpacing: 6.h,
            childAspectRatio: 0.8,
          ),
          itemCount: games.length,
          itemBuilder: (context, index) {
            return _buildGameItem(games[index]['name']!, games[index]['image']!);
          },
        ),
      ],
    );
  }

  Widget _buildGameItem(String name, String imagePath) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return FloatingGameOptions(
              gameTitle: name,
              gameImagePath: imagePath,
            );
          },
        );
      },
      child: Column(
        children: [
          Image.asset(
            imagePath,
            width: 100.w,
            height: 100.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 8.h),
          Text(
            name,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold), // Texto em negrito
          ),
        ],
      ),
    );
  }

  Widget _buildAdAtBottom() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      height: 120.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        image: DecorationImage(
          image: AssetImage('assets/jogos/banner_ad2.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Text(
          'Novidades em Breve!',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}