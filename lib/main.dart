import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sustainable_living/login.dart';
import 'package:sustainable_living/selection.dart';
import 'package:sustainable_living/signup.dart';
import 'package:sustainable_living/splash.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => SplashScreen(),
        '/Selection': (context) => const SelectionScreen(),
        '/Login': (context) => const LoginScreen(),
        '/Signup': (context) => const SignUpScreen(),
      },
    );
  }
}
