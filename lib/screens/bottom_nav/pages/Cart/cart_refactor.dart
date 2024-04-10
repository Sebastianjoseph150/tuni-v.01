
import 'package:flutter/material.dart';

Widget cartCheckoutSubHeadings({
  required String headingName,
}) {
  return Text(
    headingName,
    style: TextStyle(
        letterSpacing: 1.5, fontSize: 16, fontWeight: FontWeight.w500),
  );
}

Widget personalDetailsTextFormField(
    {required TextEditingController controller, required String hintText}) {
  return SizedBox(
    height: 50,
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10)),
          hintText: hintText,
          filled: true,
          fillColor: Colors.grey.shade100,
          labelText: hintText),
    ),
  );
}

Widget richTextInCheckout({required String content, required String text}) {
  return RichText(
    text: TextSpan(
        text: '$content: ',
        children: [
          TextSpan(
              text: text.toUpperCase(), style: TextStyle(color: Colors.black))
        ],
        style: TextStyle(color: Colors.black, letterSpacing: 0.5)),
  );
}
