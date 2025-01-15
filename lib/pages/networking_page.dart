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
              Icon(Icons.people, size: 24.sp), // Icon of two people
              SizedBox(width: 8.w), // Space between icon and text
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
            // Conteúdo da aba Explorar
            _buildExploreTab(),
            // Conteúdo da aba Grupos
            _buildGroupsTab(),
            // Conteúdo da aba Eventos
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
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.only(bottom: 12.h),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            title: Text(
              'Grupo ${index + 1}',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Descrição do grupo ${index + 1}', style: TextStyle(fontSize: 14.sp)),
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
      itemCount: userImages.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50.r,
                backgroundImage: AssetImage(userImages[index]),
              ),
              SizedBox(height: 12.h),
              Text(
                'Usuário ${index + 1}',
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
      },
    );
  }

  Widget _buildEventsTab() {
    return ListView.builder(
      padding: EdgeInsets.all(12.w),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.only(bottom: 12.h),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            title: Text(
              'Evento ${index + 1}',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4.h),
                Text('Data: ${DateTime.now().add(Duration(days: index)).toString().substring(0, 10)}', style: TextStyle(fontSize: 14.sp)),
                Text('Local: Local do evento ${index + 1}', style: TextStyle(fontSize: 14.sp)),
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
      },
    );
  }
}