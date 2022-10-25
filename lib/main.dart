import 'package:flutter/material.dart';

//Packages
import 'package:firebase_analytics/firebase_analytics.dart';

//Services
import './services/navigation_service.dart';

//Pages
import './pages/splash_page.dart';
import './pages/home_page.dart';

void main() {
  runApp(
    SplashPage(
      key: UniqueKey(),
      onInitializationComplete: () {
        runApp(
          MainApp(),
        );
      },
    ),
  );
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CompanyChat',
      theme: ThemeData(
        backgroundColor: const Color.fromRGBO(155, 217, 191, 1.0),
        scaffoldBackgroundColor: const Color.fromRGBO(155, 217, 191, 1.0),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromRGBO(79, 109, 98, 1.0),
        ),
      ),
      navigatorKey: NavigationService.navigatorKey,
      initialRoute: '/home',
      routes: {
        '/home': (BuildContext _context) => HomePage(),
      },
    );
  }
}
