import 'package:flutter/material.dart';

import '../Home/home_refactor.dart';

Widget categoriesContainer(
    {required double screenWidth, required String text}) {
  return Container(
    child: Center(
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2),
        )),
    height: 60,
    width: screenWidth,
    decoration: BoxDecoration(
        color: Colors.black87, borderRadius: BorderRadius.circular(20)),
  );
}

Widget productNameDisplay({required String text, required double size}) {
  return Expanded(
    child: Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: size, letterSpacing: 1, fontWeight: FontWeight.bold),
    ),
  );
}

Widget productView(String productName, String productPrice, String image) {
  return Padding(
    padding: EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 170,
          width: 160,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              image,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          decoration: BoxDecoration(
            // color: Colors.amber,
              borderRadius: BorderRadius.circular(30)),
        ),
        Container(
          width: 160,
          height: 60,
          padding: EdgeInsets.all(10),
          // color: Colors.red,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(productName.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: customTextStyle()),
              Text("₹${productPrice}/-", style: customTextStyle())
            ],
          ),
        ),
      ],
    ),
  );
}


Widget categoriesItems({
  required double screenWidth,
  required double screenHeight,
  required BuildContext context,
  required className,
  required String categoryName

}) {
  return SizedBox(
      width: screenWidth,
      height: screenHeight * .05,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => className,
              ));
        },
        child: Text(categoryName),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Colors.blueGrey.shade600)),
      ));

}
