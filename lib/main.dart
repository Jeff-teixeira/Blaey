import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'pages/chat/messages_page.dart';
import 'pages/fun_page.dart';
import 'pages/wallet_page.dart';
import 'pages/notifications_page.dart';
import 'auth_wrapper.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';

final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase only once
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully.");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }

  FirebaseDatabase.instance.setPersistenceEnabled(true); // Offline support

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
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
            theme: _buildTheme(Brightness.light),
            darkTheme: _buildTheme(Brightness.dark),
            themeMode: ThemeMode.system,
            home: AuthWrapper(), // Use AuthWrapper as the initial screen
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

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final seedColor = Colors.green;
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
      ),
      scaffoldBackgroundColor: isDark ? Colors.grey[900] : Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          fontSize: 16.sp,
          color: isDark ? Colors.white : Colors.black,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.sp,
          color: isDark ? Colors.white : Colors.black,
        ),
        titleLarge: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      iconTheme: IconThemeData(
        color: isDark ? Colors.white : Colors.black,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? Colors.grey[800] : Colors.white,
        selectedItemColor: seedColor,
        unselectedItemColor: isDark ? Colors.white70 : Colors.black54,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  final List<Widget> _pages = [
    MessagesPage(),
    FunPage(userBalance: 100.0),
    WalletPage(),
    NotificationsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Animate(
        child: _pages[_selectedIndex],
        effects: [FadeEffect(duration: Duration(milliseconds: 500))],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          _buildBottomNavigationBarItem(Icons.chat, 'Conversas', 0),
          _buildBottomNavigationBarItem(Icons.amp_stories, 'Diversão', 1),
          _buildBottomNavigationBarItem(Icons.account_balance_wallet, 'Carteira', 2),
          _buildBottomNavigationBarItem(Icons.notifications, 'Notificações', 3),
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
}