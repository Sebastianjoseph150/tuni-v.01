import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/auth_bloc/auth_bloc.dart';
import '../../bottom_nav/bottom_navigation_bar/pages/bottom_nav_bar_page.dart';
import '../sign_in/login.dart';
import '../sign_in/login_refactor.dart';

class SignUpBottomAppBar extends StatelessWidget {
  const SignUpBottomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.grey.shade200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Already a member?"),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LogInPage(),
                    ));
              },
              child: Text(
                "Login now",
                style: TextStyle(color: Colors.blue),
              ),
              style:
                  TextButton.styleFrom(foregroundColor: Colors.grey.shade500)),
        ],
      ),
    );
  }
}

class SignUpCollectingDetails extends StatelessWidget {
  const SignUpCollectingDetails({
    super.key,
    required this.nameController,
    required this.screenWidth,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  final TextEditingController nameController;
  final double screenWidth;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return Column(
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
        authSignUpButton(
          screenWidth,
          context: context,
          email: emailController,
          password: passwordController,
          name: nameController,
          confirmPassword: confirmPasswordController,
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
    );
  }
}

Widget sizedBox({double? height, double? width}) {
  return SizedBox(
    height: height,
    width: width,
  );
}

Widget authSignUpButton(double screenWidth,
    {required BuildContext context,
    required TextEditingController email,
    required TextEditingController password,
    required TextEditingController name,
    required TextEditingController confirmPassword}) {
  return SizedBox(
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
              email: email.text,
              password: password.text,
              confirmPassword: confirmPassword.text,
              name: name.text));
          email.clear();
          password.clear();
          name.clear();
          confirmPassword.clear();
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
  );
}
