import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuni/screens/auth/sign_in/login.dart';
import '../../../bloc/auth_bloc/auth_bloc.dart';
import '../../../bloc/auth_bloc/auth_repository.dart';
import '../../bottom_nav/bottom_navigation_bar/pages/bottom_nav_bar_page.dart';
import 'refactor.dart';
import '../sign_in/login_refactor.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthRepository signUpMethod = AuthRepository();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    signInHeading('Hello there!'),
                    Column(
                      children: [
                        sizedBox(height: 30),
                        textFormField('Full Name', nameController, screenWidth),
                        sizedBox(height: 15),
                        textFormField('Email', emailController, screenWidth),
                        sizedBox(height: 15),
                        textFormField(
                            'Password', passwordController, screenWidth),
                        sizedBox(height: 15),
                        textFormField('Confirm Password',
                            confirmPasswordController, screenWidth),
                        sizedBox(height: 15),
                        SizedBox(
                          width: screenWidth * 0.75,
                          height: 45,
                          child: BlocListener<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is LoadingState) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                );
                              }
                              if (state is AuthenticationError) {}
                              if (state is Authenticated) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const BottomNavBarPage(),
                                    ),
                                    (route) => false);
                              }
                            },
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade700,
                                  foregroundColor: Colors.grey.shade900,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)))),
                              onPressed: () {
                                context.read<AuthBloc>().add(SignUpRequestEvent(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    confirmPassword:
                                        confirmPasswordController.text,
                                    name: nameController.text));
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        // sizedBox(height: 25),
                        // SizedBox(
                        //   width: screenWidth * 0.6,
                        //   child: BlocListener<AuthBloc, AuthState>(
                        //     listener: (context, state) {
                        //       if (state is Authenticated) {
                        //         Navigator.pushAndRemoveUntil(
                        //             context,
                        //             MaterialPageRoute(
                        //               builder: (context) => const BottomNavBarPage(),
                        //             ),
                        //             (route) => false);
                        //       }
                        //     },
                        //     // child: InkWell(
                        //     //     onTap: () {
                        //     //       context.read<AuthBloc>().add(GoogleIconClickedEvent());
                        //     //     },
                        //     //     child: Container(
                        //     //         child: Image.asset(
                        //     //           'asset/icons/google_icon.png',
                        //     //           height: 40,
                        //     //         ))),
                        //   ),
                        // )
                      ],
                    ),
                  ],
                ),
              ),
            )),
            bottomNavigationBar: const SignUpBottomAppBar(),
          )
        : CupertinoPageScaffold(
            backgroundColor: CupertinoColors.systemGrey6,
            // navigationBar: CupertinoNavigationBar(),
            child: SafeArea(
              child: SizedBox(
                width: screenWidth,
                height: screenHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage("Assets/logo/tunifulllogo.png"))),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            signInHeading('SIGN UP'),
                            const SizedBox(height: 10),
                            const Text(
                              "Create a new account",
                              style:
                                  TextStyle(color: CupertinoColors.systemGrey),
                            ),

                            sizedBox(height: 30),
                            // textFormField('Full Name', nameController, screenWidth),
                            SizedBox(
                              height: 40,
                              child: CupertinoTextField(
                                padding: const EdgeInsets.only(left: 20),
                                // keyboardType: TextInputType.emailAddress,
                                controller: emailController,
                                placeholder: "Email",
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: CupertinoColors.white),
                              ),
                            ),
                            sizedBox(height: 15),
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
                            sizedBox(height: 15),
                            SizedBox(
                              height: 40,
                              child: CupertinoTextField(
                                padding: const EdgeInsets.only(left: 20),
                                obscureText: true,

                                // keyboardType: TextInputType.emailAddress,
                                controller: confirmPasswordController,
                                placeholder: "Confirm Password",
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: CupertinoColors.white),
                              ),
                            ),
                            // sizedBox(height: 15),
                            // textFormField('Confirm Password',
                            //     confirmPasswordController, screenWidth),
                            sizedBox(height: 15),
                            SizedBox(
                              height: 45,
                              child: BlocListener<AuthBloc, AuthState>(
                                listener: (context, state) {
                                  if (state is LoadingState) {
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (context) {
                                        return const Center(
                                          child: CupertinoActivityIndicator(),
                                        );
                                      },
                                    );
                                  }
                                  if (state is AuthenticationError) {}
                                  if (state is Authenticated) {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              const BottomNavBarPage(),
                                        ),
                                        (route) => false);
                                  }
                                },
                                child: Center(
                                  child: CupertinoButton.filled(
                                    // style: ElevatedButton.styleFrom(
                                    //     backgroundColor: Colors.grey.shade700,
                                    //     foregroundColor: Colors.grey.shade900,
                                    //     shape: const RoundedRectangleBorder(
                                    //         borderRadius: BorderRadius.all(
                                    //             Radius.circular(10)))),
                                    onPressed: () {
                                      if (emailController.text.isEmpty &&
                                          passwordController.text.isEmpty &&
                                          confirmPasswordController
                                              .text.isEmpty) {
                                        showCupertinoDialog(
                                          context: context,
                                          builder: (context) {
                                            return CupertinoAlertDialog(
                                              title: const Text("Empty Fields"),
                                              content: const Text(
                                                  "Please fill every fields"),
                                              actions: [
                                                CupertinoDialogAction(
                                                  child: const Text("OK"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      } else if (passwordController.text !=
                                          confirmPasswordController.text) {
                                        showCupertinoDialog(
                                          context: context,
                                          builder: (context) {
                                            return CupertinoAlertDialog(
                                              title: const Text(
                                                  "Password doesn't match"),
                                              content: const Text(
                                                  "password and confirm password doesn't match"),
                                              actions: [
                                                CupertinoDialogAction(
                                                  child: const Text("OK"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        context.read<AuthBloc>().add(
                                            SignUpRequestEvent(
                                                email: emailController.text,
                                                password:
                                                    passwordController.text,
                                                confirmPassword:
                                                    confirmPasswordController
                                                        .text,
                                                name: nameController.text));
                                      }
                                    },
                                    child: const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                          color: CupertinoColors.white,
                                          fontSize: 15,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
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
                                        builder: (context) => LogInPage(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  child: const Text(
                                    "SignUp",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20)
                            // sizedBox(height: 25),
                            // SizedBox(
                            //   width: screenWidth * 0.6,
                            //   child: BlocListener<AuthBloc, AuthState>(
                            //     listener: (context, state) {
                            //       if (state is Authenticated) {
                            //         Navigator.pushAndRemoveUntil(
                            //             context,
                            //             MaterialPageRoute(
                            //               builder: (context) => const BottomNavBarPage(),
                            //             ),
                            //             (route) => false);
                            //       }
                            //     },
                            //     // child: InkWell(
                            //     //     onTap: () {
                            //     //       context.read<AuthBloc>().add(GoogleIconClickedEvent());
                            //     //     },
                            //     //     child: Container(
                            //     //         child: Image.asset(
                            //     //           'asset/icons/google_icon.png',
                            //     //           height: 40,
                            //     //         ))),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
