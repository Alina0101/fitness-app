import 'package:fitness_app/view/bottom_navigation_bar/navigation_menu.dart';
import 'package:fitness_app/controller/context_controller.dart';
import 'package:fitness_app/controller/uni_controller.dart';
import 'package:fitness_app/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'view/auth/auth_page.dart';
import 'view/auth/screens/login_screen.dart';
import 'view/auth/screens/registration_screen.dart';
import 'view/auth/screens/reset_pw_screen.dart';
import 'view/user_account/user_account_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await UniController.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: ContextUtility.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: CustomAppTheme.myTheme,
      routes: {
        '/': (context) => const AuthPage(),
        '/login': (context) => LoginScreen(),
        '/registration': (context) => RegistrationScreen(),
        '/home': (context) => UserAccountScreen(),
        '/reset_pw': (context) => ResetPasswordScreen(),
        '/nav_menu': (context) => NavigationMenu(),
      },
    );
  }
}
