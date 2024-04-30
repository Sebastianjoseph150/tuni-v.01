import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuni/screens/auth/sign_up/sign_up.dart';
import '../../../bloc/auth_bloc/auth_bloc.dart';
import '../../bottom_nav/bottom_navigation_bar/pages/bottom_nav_bar_page.dart';
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
    return Platform.isAndroid
        ? Scaffold(
            backgroundColor: Colors.grey.shade200,
            body: SafeArea(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: screenWidth,
                  height: screenHeight,
                  child: Column(
                    children: [
                      sizedBox(height: screenHeight * 0.2),
                      const LoginWelcomeMessage(),
                      LoginCollectingEmailAndPassword(
                          emailController: emailController,
                          screenWidth: screenWidth,
                          passwordController: passwordController),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: const LoginBottomAppBar(),
          )
        : CupertinoPageScaffold(
            backgroundColor: CupertinoColors.systemGrey6,
            child: SafeArea(
              child: SizedBox(
                // color: Colors.amberAccent,
                height: screenHeight,
                width: screenWidth,
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage("Assets/logo/tunifulllogo.png"))),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const LoginWelcomeMessage(),
                          sizedBox(height: screenHeight * 0.05),
                          SizedBox(
                            height: 40,
                            child: CupertinoTextField(
                              padding: const EdgeInsets.only(left: 20),
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              placeholder: "Email",
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: CupertinoColors.white),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 40,
                            child: CupertinoTextField(
                              padding: const EdgeInsets.only(left: 20),
                              obscureText: true,
                              controller: passwordController,
                              placeholder: "Password",
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: CupertinoColors.white),
                            ),
                          ),
                          const SizedBox(height: 20),
                          BlocListener<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is LoadingState) {
                              } else if (state is Authenticated) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          const BottomNavBarPage(),
                                    ),
                                    (route) => false);
                              } else if (state is AuthenticationError) {
                                showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: const Text('Sign In Failed'),
                                      content: const Text(
                                          "Email and Password doesn't match."),
                                      actions: [
                                        CupertinoDialogAction(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: Center(
                              child: CupertinoButton.filled(
                                  child: const Text("Login"),
                                  onPressed: () {
                                    if (emailController.text.isEmpty ||
                                        passwordController.text.isEmpty) {
                                      showCupertinoDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: const Text('Empty Fields!!'),
                                            content: const Text(
                                                "Mandatory fields can't be empty"),
                                            actions: [
                                              CupertinoDialogAction(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("OK")),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      context.read<AuthBloc>().add(
                                          SignInRequestEvent(
                                              email: emailController.text,
                                              password:
                                                  passwordController.text));
                                      emailController.clear();
                                      passwordController.clear();
                                    }
                                  }),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Not a member? ",
                          style: TextStyle(
                            letterSpacing: 1,

                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const SignUpPage(),
                              ),
                              (route) => false,
                            );
                          },
                          child: const Text(
                            "SignUp",
                            style: TextStyle(
                              color:
                                  Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
            ),
          );
  }
}
