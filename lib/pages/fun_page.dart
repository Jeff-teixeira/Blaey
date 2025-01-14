import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'profile_page.dart' as profile;
import 'trophies_page.dart';
import 'friend_profile_page.dart' as friendProfile;
import 'store_page.dart';
import 'blaey_page.dart';
import 'floating_dialog.dart';

class FunPage extends StatefulWidget {
  final double userBalance;

  FunPage({required this.userBalance});

  @override
  _FunPageState createState() => _FunPageState();
}

class _FunPageState extends State<FunPage> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
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
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(1.w),
          children: [
            _buildAppBar(),
            SizedBox(height: 21.h),
            _buildBannerCarousel(),
            SizedBox(height: 15.h),
            _buildPageIndicators(),
            SizedBox(height: 15.h),
            _buildOnlineStatus(),
            SizedBox(height: 4.h),
            _buildUserCarousel(),
            SizedBox(height: 1.h),
            _buildRecentGames(),
            SizedBox(height: 20.h),
            _buildTournamentsAndEvents(),
            SizedBox(height: 20.h),
            _buildAllGamesGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(26.r),
            border: Border.all(color: Colors.green, width: 1),
          ),
          child: Row(
            children: [
              Image.asset(
                'assets/icons/moeda.png',
                width: 24.w,
                height: 24.h,
              ),
              SizedBox(width: 6.w),
              Text(
                '\$${widget.userBalance.toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),
              SizedBox(width: 9.w),
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
            backgroundImage: AssetImage('assets/icons/perfil.png'),
          ),
        ),
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
      ],
    );
  }

  Widget _buildBannerCarousel() {
    return Container(
      height: 140.h,
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
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
            (index) => Container(
          width: 59.0,
          height: 6.0,
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.0),
            color: _currentPage == index ? Colors.black54 : Colors.white60,
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineStatus() {
    return Row(
      children: [
        Icon(
          Icons.circle,
          color: Colors.green,
          size: 11.sp,
        ),
        SizedBox(width: 8.w),
        Text(
          'Online',
          style: TextStyle(fontSize: 11.5.sp, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildUserCarousel() {
    return Container(
      height: 140.h,
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
                SizedBox(height: 4.h),
                Text(
                  userName,
                  style: TextStyle(fontSize: 12.sp),
                ),
                SizedBox(height: 4.h),
                ElevatedButton(
                  onPressed: () {
                    // Implementar lógica de desafio
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Desafiar',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentGames() {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.timelapse,
              color: Colors.black12,
            ),
            SizedBox(width: 4.w),
            Text(
              'Recentes',
              style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.bold, color: Colors.black12),
            ),
          ],
        ),
        SizedBox(height: 7.h),
        Container(
          height: 140.h,
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
                        return FloatingDialog(gameTitle: recentGames[index]['name']!);
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
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTournamentsAndEvents() {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.event,
              color: Colors.black54,
            ),
            SizedBox(width: 8.w),
            Text(
              'Torneios e Eventos',
              style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Container(
          height: 100.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              final events = [
                {'title': 'Torneio de Xadrez', 'date': '15 Jun'},
                {'title': 'Campeonato de Damas', 'date': '22 Jun'},
                {'title': 'Maratona de Ludo', 'date': '30 Jun'},
              ];
              return Container(
                width: 190.w,
                margin: EdgeInsets.only(right: 16.w),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      events[index]['title']!,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      events[index]['date']!,
                      style: TextStyle(fontSize: 12.sp, color: Colors.white),
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

  Widget _buildAllGamesGrid() {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.games_rounded,
              color: Colors.amber,
            ),
            SizedBox(width: 4.w),
            Text(
              'Todos os Jogos',
              style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 18.w,
            mainAxisSpacing: 6.h,
            childAspectRatio: 0.8,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            final games = [
              {'name': 'Dama', 'image': 'assets/jogos/dama.png'},
              {'name': 'Xadrez', 'image': 'assets/jogos/xadrez.png'},
              {'name': 'Ludo', 'image': 'assets/jogos/ludo.png'},
              {'name': 'Truco', 'image': 'assets/jogos/truco.png'},
              {'name': 'Jogo da Velha', 'image': 'assets/jogos/jogo_da_velha.png'},
              {'name': 'Outro Jogo', 'image': 'assets/jogos/dama.png'},
            ];
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
            return FloatingDialog(gameTitle: name);
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
            style: TextStyle(fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}