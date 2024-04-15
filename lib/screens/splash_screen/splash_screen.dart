import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth/sign_in/login.dart';
import '../bottom_nav/bottom_navigation_bar/pages/bottom_nav_bar_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;
    return FlutterSplashScreen.fadeIn(
      animationDuration: Duration(seconds: 4),
      duration: Duration(seconds: 3),
      backgroundColor: Color.fromARGB(255, 83, 26, 151),
      childWidget: SizedBox(
        height: 300,
        width: 300,
        child: Image.asset("Assets/LOGO.png"),
      ),
      nextScreen: user != null ? BottomNavBarPage() : LogInPage(),
    );
  }
}
