import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/auth_service.dart';
import 'widgets/auth_wrapper.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/chat/messages_page.dart';
import 'pages/fun_page.dart';
import 'pages/wallet_page.dart';
import 'pages/notifications_page.dart';
import 'pages/networking_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: (context, child) {
        return MaterialApp(
          title: 'Blaey',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'SFProText', // Fonte padrão
            scaffoldBackgroundColor: Color(0xFFF5F5F7), // Define o fundo de tela padrão
          ),
          home: AuthWrapper(),
          routes: {
            '/login': (context) => LoginPage(),
            '/register': (context) => RegisterPage(),
          },
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  int _currentIndex = 1;

  final List<Widget> _pages = [
    MessagesPage(),
    FunPage(userBalance: 0.0),
    NetworkingPage(),
    WalletPage(),
    NotificationsPage(),
  ];

  @override
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF5F5F7), // Mesma cor do scaffoldBackgroundColor
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 4,
              offset: Offset(0, -1), // Sombra na parte superior
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          iconSize: 24,
          selectedLabelStyle: TextStyle(
            fontFamily: 'SFProDisplay',
            fontWeight: FontWeight.w600, // Semibold
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'SFProText',
            fontWeight: FontWeight.w600, // Semibold
          ),
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.transparent, // Torna o fundo transparente
          elevation: 0, // Remove a sombra padrão
          items: [
            _buildNavigationBarItem(Icons.message, 0, 'Conversas'),
            _buildNavigationBarItem(Icons.videogame_asset_rounded, 1, 'Diversão'),
            _buildNavigationBarItem(Icons.people, 2, 'Networking'),
            _buildNavigationBarItem(Icons.account_balance_wallet, 3, 'Carteira'),
            _buildNavigationBarItem(Icons.notifications, 4, 'Notificações'),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavigationBarItem(IconData icon, int index, String label) {
    return BottomNavigationBarItem(
      icon: Container(
        decoration: BoxDecoration(
          color: _currentIndex == index ? Colors.green.withAlpha(77) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: EdgeInsets.all(4),
        child: Icon(
          icon,
          color: _currentIndex == index ? Colors.black : Colors.grey,
        ),
      ),
      label: label,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
