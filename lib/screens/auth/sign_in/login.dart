import 'package:flutter/material.dart';
import '../sign_up/refactor.dart';
import 'login_refactor.dart';

class LogInPage extends StatelessWidget {
  LogInPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Column(
              children: [
                sizedBox(height: screenHeight * 0.2),
                LoginWelcomeMessage(),
                LoginCollectingEmailAndPassword(
                    emailController: emailController,
                    screenWidth: screenWidth,
                    passwordController: passwordController),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: LoginBottomAppBar(),
    );
  }
}
