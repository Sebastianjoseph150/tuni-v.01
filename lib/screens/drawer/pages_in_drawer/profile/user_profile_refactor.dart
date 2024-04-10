import 'package:flutter/material.dart';

class UserProfileTextFormField extends StatelessWidget {
  final String text;
  final TextEditingController controller;

  const UserProfileTextFormField(
      {super.key, required this.text, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: text,
          filled: true,
          fillColor: Colors.grey.shade300,
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

class UserProfileElevatedButton extends StatelessWidget {
  const UserProfileElevatedButton({
    super.key,
    required this.screenWidth,
  });

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth * .5,
      height: 45,
      child: ElevatedButton(
        onPressed: () {},
        child: Text("Add details"),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}

Text userDetailsDisplayingText(dynamic text) {
  return Text(
    text.toString(),
    style: TextStyle(
        fontSize: 15, letterSpacing: 2, fontWeight: FontWeight.w400),
  );
}

Text userDetailsHeadingText({required String text}) {
  return Text(
    text,
    style: TextStyle(
      color: Colors.grey,
      letterSpacing: 2,
    ),
  );
}
