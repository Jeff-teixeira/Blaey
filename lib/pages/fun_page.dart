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
  String? _selectedOption;
  String? _selectedBettingMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            // Custom AppBar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        print("Navegando para a página de perfil");
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
                ),
                Row(
                  children: [
                    // Container do saldo com o botão verde dentro da borda
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(26.r),
                        border: Border.all(color: Colors.green, width: 1), // Borda verde
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
                          // Botão verde dentro da borda
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => StorePage(updateBalance: (amount) {})),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.w),
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
                    SizedBox(width: 16.w),
                    // Ícone de pesquisa
                    InkWell(
                      onTap: () {
                        print("Ícone de pesquisa tocado");
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
            ),
            SizedBox(height: 4.h),

            // Recentes
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
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return FloatingDialog(gameTitle: recentGames[index]['name']!);
                          },
                        );
                      },
                      child: AspectRatio(
                        aspectRatio: 1,
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

            // Torneios e Eventos
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
              height: 120.h,
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
                    width: 150.w,
                    margin: EdgeInsets.only(right: 16.w),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          events[index]['title']!,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          events[index]['date']!,
                          style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 26.h),

            // Estatísticas
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
            SizedBox(height: 16.h),
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

            // Todos os jogos
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
                InkWell(
                  onTap: () {
                    _showFilterDialog();
                  },
                  child: Icon(
                    Icons.filter_list,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                final games = [
                  {'image': 'assets/jogos/dama.png', 'name': 'Dama'},
                  {'image': 'assets/jogos/xadrez.png', 'name': 'Xadrez'},
                  {'image': 'assets/jogos/ludo.png', 'name': 'Ludo'},
                  {'image': 'assets/jogos/domino.png', 'name': 'Dominó'},
                  {'image': 'assets/jogos/uno.png', 'name': 'Uno'},
                  {'image': 'assets/jogos/poker.png', 'name': 'Poker'},
                ];
                return InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return FloatingDialog(gameTitle: games[index]['name']!);
                      },
                    );
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Image.asset(
                            games[index]['image']!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        games[index]['name']!,
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticCard(String period, String games) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            period,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
          SizedBox(height: 4.h),
          Text(
            games,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filtrar Jogos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: _selectedOption,
                hint: Text('Selecione uma categoria'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedOption = newValue;
                  });
                },
                items: <String>['Tabuleiro', 'Cartas', 'Estratégia', 'Todos']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              DropdownButton<String>(
                value: _selectedBettingMode,
                hint: Text('Modo de apostas'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedBettingMode = newValue;
                  });
                },
                items: <String>['Com apostas', 'Sem apostas', 'Todos']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Aplicar'),
              onPressed: () {
                // Implement filter logic here
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}