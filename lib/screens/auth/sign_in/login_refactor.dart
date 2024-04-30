import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/auth_bloc/auth_bloc.dart';
import '../../bottom_nav/bottom_navigation_bar/pages/bottom_nav_bar_page.dart';
import '../sign_up/refactor.dart';
import '../sign_up/sign_up.dart';

class LoginBottomAppBar extends StatelessWidget {
  const LoginBottomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 0,
      color: Colors.grey.shade200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Not a member?"),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpPage(),
                    ));
              },
              style:
                  TextButton.styleFrom(foregroundColor: Colors.grey.shade500),
              child: const Text(
                "Register Now",
                style: TextStyle(color: Colors.blue),
              )),
        ],
      ),
    );
  }
}

class LoginCollectingEmailAndPassword extends StatelessWidget {
  const LoginCollectingEmailAndPassword({
    super.key,
    required this.emailController,
    required this.screenWidth,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final double screenWidth;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        sizedBox(height: 30),
        textFormField('Email', emailController, screenWidth),
        sizedBox(height: 15),
        textFormField('Password', passwordController, screenWidth),
        sizedBox(height: 15),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is LoadingState) {
              showDialog(
                context: context,
                builder: (context) {
                  return const Center(child: CircularProgressIndicator());
                },
              );
            } else if (state is Authenticated) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BottomNavBarPage(),
                  ),
                  (route) => false);
            } else if (state is AuthenticationError) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Sign In Failed'),
                    content:
                        const Text("The provided credentials are incorrect."),
                    actions: [
                      TextButton(
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
          child: authSignInButton(screenWidth,
              context: context,
              email: emailController,
              password: passwordController),
        ),
        SizedBox(
          height: 35,
          width: screenWidth * 0.75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {}, child: const Text('Forgot Password?'))
            ],
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
                        builder: (context) => const BottomNavBarPage(),
                      ),
                      (route) => false);
                }
              },
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.red)),
                  onPressed: () {
                    // String? uid =
                    //     await GoogleSignInProvider().signInWithGoogle();
                    // if (uid != null) {
                    //   // Sign-in successful, handle navigation or other actions
                    //   print('Signed in with UID: $uid');
                    // } else {
                    //   // Handle sign-in failure
                    //   print('Sign-in failed.');
                    // }
                    // try {
                    //   String? credential =
                    //       await GoogleSignInProvider().signInWithGoogle();
                    //   if (credential != null) {
                    //     // Sign-in successful, handle navigation or other actions
                    //     print('Signed in with credential: $credential');
                    //     Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => BottomNavBarPage()));
                    //   } else {
                    //     // Handle sign-in failure
                    //     print('Sign-in failed.');
                    //   }
                    // } catch (error) {
                    //   // Handle any errors that occur during sign-in
                    //   print('Error signing in: $error');
                    // }
                    context.read<AuthBloc>().add(SignInRequestEvent(
                        email: 'guest@gmail.com', password: 'guest@123'));
                  },
                  child: const Text(
                    ' + Guest Account ',
                    style: TextStyle(color: Colors.white),
                  ))),
        )
      ],
    );
  }
}

class LoginWelcomeMessage extends StatelessWidget {
  const LoginWelcomeMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          signInHeading(
            'WELCOME!',
          ),
          const SizedBox(height: 10),
          const Text(
            "Please login or signup to continue our app",
            style: TextStyle(color: CupertinoColors.systemGrey),
          )
        ],
      ),
    );
  }
}

Widget authSignInButton(double screenWidth,
    {required BuildContext context,
    required TextEditingController email,
    required TextEditingController password}) {
  return SizedBox(
    width: screenWidth * 0.75,
    height: 45,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade700,
          foregroundColor: Colors.grey.shade900,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)))),
      onPressed: () {
        if (email.text.isEmpty || password.text.isEmpty) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Empty Fields'),
                content: const Text("Mandatory fields can't be empty"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          context.read<AuthBloc>().add(
              SignInRequestEvent(email: email.text, password: password.text));
          email.clear();
          password.clear();
        }
      },
      child: const Text(
        'Sign In',
        style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            letterSpacing: 1,
            fontWeight: FontWeight.bold),
      ),
    ),
  );
}

// Widget authSignInButton(double screenWidth,
//     {required BuildContext context,
//     required TextEditingController email,
//     required TextEditingController password}) {
//   return SizedBox(
//     width: screenWidth * 0.75,
//     height: 45,
//     child: ElevatedButton(
//       style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.grey.shade700,
//           foregroundColor: Colors.grey.shade900,
//           shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10)))),
//       onPressed: () {
//         context.read<AuthBloc>().add(
//             SignInRequestEvent(email: email.text, password: password.text));
//         email.clear();
//         password.clear();
//       },
//       child: const Text(
//         'Sign In',
//         style: TextStyle(
//             color: Colors.white,
//             fontSize: 15,
//             letterSpacing: 1,
//             fontWeight: FontWeight.bold),
//       ),
//     ),
//   );
// }

Widget textFormField(String hintText, controller, double screenWidth) {
  return SizedBox(
    width: screenWidth * 0.75,
    child: Platform.isAndroid? TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Mandatory fields can't be empty";
        }
        return null;
      },
      controller: controller,
      obscureText: hintText == 'Password' || hintText == 'Confirm Password'
          ? true
          : false,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade500)),
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10)),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
      ),
    ) :
    CupertinoTextField(
      controller: controller,
      obscureText: hintText == 'Password' || hintText == 'Confirm Password'
          ? true
          : false,
      placeholder: hintText,
    )
    ,

  );
}

Widget signInHeading(String heading) {
  return Text(heading,
      style: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        letterSpacing: 3,
        fontWeight: FontWeight.w700,
      ));
}

Widget signInTextQuote(String text) {
  return Text(text,
      style: const TextStyle(
        fontSize: 15,
        color: Colors.white,
        letterSpacing: 1,
        fontWeight: FontWeight.w700,
      ));
}
