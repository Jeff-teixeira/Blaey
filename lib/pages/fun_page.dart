import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'profile_page.dart' as profile;
import 'trophies_page.dart';
import 'friend_profile_page.dart' as friendProfile;
import 'store_page.dart';
import 'waiting_for_player_page.dart';
import 'waiting_direto.dart';
import 'filter_dialog.dart';
import 'blaey_page.dart';
import 'floating_dialog.dart'; // Importe a FloatingDialog

class FunPage extends StatefulWidget {
  final double userBalance;

  FunPage({required this.userBalance});

  @override
  _FunPageState createState() => _FunPageState();
}

class _FunPageState extends State<FunPage> {
  bool isOnline = true;
  bool isDarkMode = false;
  String? _selectedOption;
  String? _selectedBettingMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom AppBar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => profile.ProfilePage()),
                            );
                          },
                          child: CircleAvatar(
                            radius: 27.r,
                            backgroundColor: const Color(0xFFE7DFEC),
                            backgroundImage: AssetImage('assets/icons/perfil.png'),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TrophiesPage()),
                            );
                          },
                          child: Icon(
                            Icons.emoji_events,
                            size: 33.sp,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '\$${widget.userBalance.toStringAsFixed(2)}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                        ),
                        SizedBox(width: 2.w),
                        Image.asset(
                          'assets/icons/moeda.png',
                          width: 24.w,
                          height: 24.h,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => StorePage(updateBalance: (amount) {})),
                            );
                          },
                          child: Icon(
                            Icons.store,
                            size: 30.sp,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        GestureDetector(
                          onTap: () {
                            // Implement search functionality here
                          },
                          child: Image.asset(
                            'assets/images/pesquisa.png',
                            width: 30.w,
                            height: 30.h,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Sala de jogos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sala de jogos',
                      style: TextStyle(fontSize: 29.sp, fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                    // O ícone de filtro foi removido daqui
                  ],
                ),
                SizedBox(height: 21.h),

                // Status Online
                Row(
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
                ),
                SizedBox(height: 8.h),

                // Carrossel de usuários
                Container(
                  height: 140.h, // Aumentei a altura para acomodar o botão
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
                            GestureDetector(
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
                ),
                SizedBox(height: 4.h),

                Row(
                  children: [
                    Icon(
                      Icons.timelapse,
                      color: Colors.black12,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Recentes',
                      style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.bold, color: Colors.black12),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
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
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return FloatingDialog(gameTitle: recentGames[index]['name']!);
                              },
                            );
                          },
                          child: AspectRatio(
                            aspectRatio: 1, // Mantém a imagem quadrada
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: Image.asset(
                                recentGames[index]['image']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 26.h),
                Row(
                  children: [
                    Icon(
                      Icons.timeline_sharp,
                      color: Colors.black54,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Estatísticas',
                      style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                  ],
                ),
                SizedBox(height: 26.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildStatisticCard('Semana', '5 jogos'),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _buildStatisticCard('Mês', '20 jogos'),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _buildStatisticCard('Ano', '200 jogos'),
                    ),
                  ],
                ),
                SizedBox(height: 26.h),
                Row(
                  children: [
                    Icon(
                      Icons.videogame_asset_outlined,
                      color: Colors.black54,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'Todos os jogos',
                        style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 7.w,
                    mainAxisSpacing: 24.h,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final allGames = [
                      {'image': 'assets/jogos/dama.png', 'name': 'Dama'},
                      {'image': 'assets/jogos/truco.png', 'name': 'Truco'},
                      {'image': 'assets/jogos/xadrez.png', 'name': 'Xadrez'},
                      {'image': 'assets/jogos/jogo_da_velha.png', 'name': 'Jogo da Velha'},
                      {'image': 'assets/jogos/ludo.png', 'name': 'Ludo'},
                    ];
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return FloatingDialog(gameTitle: allGames[index]['name']!);
                          },
                        );
                      },
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3.r),
                            child: Image.asset(
                              allGames[index]['image']!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            allGames[index]['name']!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticCard(String title, String count) {
    return Container(
      padding: EdgeInsets.all(8.w),
      width: 100.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          SizedBox(height: 9.h),
          Text(
            count,
            style: TextStyle(fontSize: 12.sp, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}