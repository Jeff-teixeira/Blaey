import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'services/auth_service.dart';
import 'widgets/auth_wrapper.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/chat/messages_page.dart';
import 'pages/fun_page.dart';
import 'pages/wallet_page.dart';
import 'pages/notifications_page.dart';

// Remove this line if it exists:
// import 'pages/home_page.dart';

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
  int _currentIndex = 1; // Start on the FunPage

  final List<Widget> _pages = [
    MessagesPage(), // Moved MessagesPage to the first position
    FunPage(userBalance: 0.0),
    NetworkingPage(),
    WalletPage(),
    NotificationsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
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
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        selectedItemColor: Colors.black, // Black text for selected item
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                color: _currentIndex == 0 ? Colors.green.withOpacity(0.3) : Colors.transparent, // More transparent green
                borderRadius: BorderRadius.circular(8),
              ),
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4), // Wider margin for the icon
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.message,
                color: _currentIndex == 0 ? Colors.black : Colors.grey, // Black icon for selected
              ),
            ),
            label: 'Conversas',
          ),
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                color: _currentIndex == 1 ? Colors.green.withOpacity(0.3) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4), // Wider margin for the icon
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.videogame_asset_rounded,
                color: _currentIndex == 1 ? Colors.black : Colors.grey,
              ),
            ),
            label: 'Diversão',
          ),
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                color: _currentIndex == 2 ? Colors.green.withOpacity(0.3) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              margin: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.people,
                color: _currentIndex == 2 ? Colors.black : Colors.grey,
              ),
            ),
            label: 'Networking',
          ),
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                color: _currentIndex == 3 ? Colors.green.withOpacity(0.3) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.account_balance_wallet,
                color: _currentIndex == 3 ? Colors.black : Colors.grey,
              ),
            ),
            label: 'Carteira',
          ),
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                color: _currentIndex == 4 ? Colors.green.withOpacity(0.3) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.notifications,
                color: _currentIndex == 4 ? Colors.black : Colors.grey,
              ),
            ),
            label: 'Notificações',
          ),
        ],
      )
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class NetworkingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Networking Page'),
    );
  }
}
