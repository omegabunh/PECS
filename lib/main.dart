import 'firebase_options.dart';

//Packages
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
import './pages/forgat_password_page.dart';

//Models
import './models/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/config/.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
              create: (BuildContext context) {
                return AuthenticationProvider();
              },
            )
          ],
          child: MaterialApp(
            title: 'PECS',
            theme: themeNotifier.isDark ? darkThemeData : lightThemeData,
            navigatorKey: NavigationService.navigatorKey,
            initialRoute: '/login',
            routes: {
              '/login': (BuildContext context) => const LoginPage(),
              '/register': (BuildContext context) => const RegisterPage(),
              '/password': (BuildContext context) => ForgotPasswordPage(),
              '/home': (BuildContext context) => const HomePage(),
            },
            debugShowCheckedModeBanner: false,
          ),
        );
      }),
    );
  }
}
