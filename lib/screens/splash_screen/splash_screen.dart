import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
      animationDuration: Duration(seconds: 7),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.white,
      childWidget: SizedBox(
          height: 500,
          width: 300,
          child:
              Lottie.asset('Assets/Animations/Animation - 1713270854970.json')
          //  Image.asset("Assets/LOGO.png"),
          ),
      nextScreen: user != null ? BottomNavBarPage() : LogInPage(),
    );
  }
}
