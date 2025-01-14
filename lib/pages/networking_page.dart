import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NetworkingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(Icons.people, size: 24.sp), // Ícone de duas pessoas
              SizedBox(width: 8.w), // Espaço entre o ícone e o texto
              Text('Networking', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
            ],
          ),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.explore), text: 'Explorar'),
              Tab(icon: Icon(Icons.group), text: 'Grupos'),
              Tab(icon: Icon(Icons.event), text: 'Eventos'),
            ],
            labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(fontSize: 14.sp),
            indicatorColor: Colors.white,
            indicatorWeight: 3,
          ),
          elevation: 0,
        ),
        body: TabBarView(
          children: [
            _buildExploreTab(),
            _buildGroupsTab(),
            _buildEventsTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Ação ao clicar no botão
          },
          backgroundColor: Colors.green,
          child: Icon(Icons.add, color: Colors.white, size: 30.r),
        ),
      ),
    );
  }

  Widget _buildGroupsTab() {
    return ListView.builder(
      padding: EdgeInsets.all(12.w),
      itemCount: 10 + (10 ~/ 3), // Adiciona espaço para anúncios
      itemBuilder: (context, index) {
        if ((index + 1) % 4 == 0) { // A cada 3 grupos, exibe um anúncio
          return Card(
            margin: EdgeInsets.only(bottom: 12.h),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            color: Colors.deepPurple, // Fundo roxo
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              title: Text(
                'Anúncio',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              subtitle: Text(
                'Este é um anúncio relevante para você.',
                style: TextStyle(fontSize: 14.sp, color: Colors.white),
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 25.r,
                child: Icon(Icons.ads_click, size: 30.r, color: Colors.deepPurple),
              ),
            ),
          );
        } else {
          final groupIndex = index - (index ~/ 4); // Ajusta o índice para pegar o grupo correto
          return Card(
            margin: EdgeInsets.only(bottom: 12.h),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              title: Text(
                'Grupo ${groupIndex + 1}',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Descrição do grupo ${groupIndex + 1}', style: TextStyle(fontSize: 14.sp)),
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 25.r,
                child: Icon(Icons.group, size: 30.r, color: Colors.white),
              ),
              onTap: () {
                // Ação ao clicar no grupo
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildExploreTab() {
    final userImages = [
      'assets/users/oponente.png',
      'assets/users/oponente1.png',
      'assets/users/oponente2.png',
      'assets/users/oponente3.png',
      'assets/users/oponente4.png',
      'assets/users/oponente5.png',
    ];

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.8,
      ),
      padding: EdgeInsets.all(12.w),
      itemCount: userImages.length + (userImages.length ~/ 3), // Adiciona espaço para anúncios
      itemBuilder: (context, index) {
        if ((index + 1) % 4 == 0) { // A cada 3 usuários, exibe um anúncio
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            color: Colors.deepPurple, // Fundo roxo
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.ads_click, size: 50.r, color: Colors.white),
                SizedBox(height: 12.h),
                Text(
                  'Anúncio',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Conheça nossas ofertas!',
                  style: TextStyle(fontSize: 14.sp, color: Colors.white),
                ),
              ],
            ),
          );
        } else {
          final userIndex = index - (index ~/ 4); // Ajusta o índice para pegar o usuário correto
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50.r,
                  backgroundImage: AssetImage(userImages[userIndex]),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Usuário ${userIndex + 1}',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.h),
                ElevatedButton(
                  onPressed: () {
                    // Ação para conectar
                  },
                  child: Text('Conectar', style: TextStyle(fontSize: 14.sp, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildEventsTab() {
    return ListView.builder(
      padding: EdgeInsets.all(12.w),
      itemCount: 10 + (10 ~/ 3), // Adiciona espaço para anúncios
      itemBuilder: (context, index) {
        if ((index + 1) % 4 == 0) { // A cada 3 eventos, exibe um anúncio
          return Card(
            margin: EdgeInsets.only(bottom: 12.h),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            color: Colors.deepPurple, // Fundo roxo
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              title: Text(
                'Anúncio',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              subtitle: Text(
                'Confira nossas promoções!',
                style: TextStyle(fontSize: 14.sp, color: Colors.white),
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 25.r,
                child: Icon(Icons.ads_click, size: 30.r, color: Colors.deepPurple),
              ),
            ),
          );
        } else {
          final eventIndex = index - (index ~/ 4); // Ajusta o índice para pegar o evento correto
          return Card(
            margin: EdgeInsets.only(bottom: 12.h),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              title: Text(
                'Evento ${eventIndex + 1}',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.h),
                  Text('Data: ${DateTime.now().add(Duration(days: eventIndex)).toString().substring(0, 10)}', style: TextStyle(fontSize: 14.sp)),
                  Text('Local: Local do evento ${eventIndex + 1}', style: TextStyle(fontSize: 14.sp)),
                ],
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.red,
                radius: 25.r,
                child: Icon(Icons.event, size: 30.r, color: Colors.white),
              ),
              onTap: () {
                // Ação ao clicar no evento
              },
            ),
          );
        }
      },
    );
  }
}