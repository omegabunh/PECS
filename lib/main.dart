import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './models/theme.dart';

//Packages
import 'package:provider/provider.dart';

//Services
import 'providers/theme_provider.dart';
import 'services/navigation_service.dart';

//Providers
import './providers/authentication_provider.dart';

//Pages
import './pages/splash_page.dart';
import './pages/login_page.dart';
import './pages/register_page.dart';
import './pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    SplashPage(
      key: UniqueKey(),
      onInitializationComplete: () {
        runApp(
          const MainApp(),
        );
      },
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthenticationProvider>(
              create: (BuildContext _context) {
                return AuthenticationProvider();
              },
            )
          ],
          child: MaterialApp(
            title: 'EsportsCAL',
            theme: themeNotifier.isDark ? darkThemeData : lightThemeData,
            navigatorKey: NavigationService.navigatorKey,
            initialRoute: '/home',
            routes: {
              // '/login': (BuildContext _context) => const LoginPage(),
              // '/register': (BuildContext _context) => RegisterPage(),
              '/home': (BuildContext _context) => HomePage(),
            },
            debugShowCheckedModeBanner: false,
          ),
        );
      }),
    );
  }
}
