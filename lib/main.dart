import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'services/auth_service.dart';
import 'widgets/auth_wrapper.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/chat/messages_page.dart';
import 'pages/fun_page.dart';
import 'pages/wallet_page.dart';
import 'pages/notifications_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            Provider<AuthService>(
              create: (_) => AuthService(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Blaey App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: AuthWrapper(),
            routes: {
              '/login': (context) => LoginPage(),
              '/register': (context) => RegisterPage(),
              '/home': (context) => HomePage(),
            },
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: analytics),
            ],
          ),
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
  int _selectedIndex = 1;
  double userBalance = 100.0; // Example balance
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      MessagesPage(),
      FunPage(userBalance: userBalance),
      NetworkingPage(),
      WalletPage(),
      NotificationsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          _buildBottomNavigationBarItem(Icons.chat, 'Conversas', 0),
          _buildBottomNavigationBarItem(Icons.amp_stories, 'Diversão', 1),
          _buildBottomNavigationBarItem(Icons.people, 'Networking', 2),
          _buildBottomNavigationBarItem(Icons.account_balance_wallet, 'Carteira', 3),
          _buildBottomNavigationBarItem(Icons.notifications, 'Notificações', 4),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedFontSize: 12.sp,
        unselectedFontSize: 12.sp,
        iconSize: 24.sp,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[100] : Colors.transparent,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.black : Colors.black54,
        ),
      ),
      label: label,
      backgroundColor: Colors.white,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class NetworkingPage extends StatelessWidget {
  const NetworkingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Networking Page'),
      ),
    );
  }
}
