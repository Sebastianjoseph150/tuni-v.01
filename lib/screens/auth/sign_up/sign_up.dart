import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/auth_bloc/auth_bloc.dart';
import '../../../bloc/auth_bloc/auth_repository.dart';
import '../../bottom_nav/bottom_navigation_bar/pages/bottom_nav_bar_page.dart';
import 'refactor.dart';
import '../sign_in/login_refactor.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

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

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
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
                textFormField('Password', passwordController, screenWidth),
                sizedBox(height: 15),
                textFormField(
                    'Confirm Password', confirmPasswordController, screenWidth),
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
                            return Center(
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
                              builder: (context) => BottomNavBarPage(),
                            ),
                                (route) => false);
                      }
                    },
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade700,
                          foregroundColor: Colors.grey.shade900,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)))),
                      onPressed: () {
                        context.read<AuthBloc>().add(SignUpRequestEvent(
                            email: emailController.text,
                            password: passwordController.text,
                            confirmPassword: confirmPasswordController.text,
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
                sizedBox(height: 25),
                SizedBox(
                  width: screenWidth * 0.6,
                  child: BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is Authenticated) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BottomNavBarPage(),
                            ),
                                (route) => false);
                      }
                    },
                    child: InkWell(
                        onTap: () {
                          context.read<AuthBloc>().add(GoogleIconClickedEvent());
                        },
                        child: Container(
                            child: Image.asset(
                              'asset/icons/google_icon.png',
                              height: 40,
                            ))),
                  ),
                )
              ],
            ),
          ],
        ),
      )),
      bottomNavigationBar: SignUpBottomAppBar(),
    );
  }
}
