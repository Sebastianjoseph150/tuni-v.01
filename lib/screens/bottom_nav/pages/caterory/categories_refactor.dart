import 'package:flutter/material.dart';


import '../Home/home_refactor.dart';

Widget categoriesContainer(
    {required double screenWidth, required String text}) {
  return Container(
    height: 60,
    width: screenWidth,
    decoration: BoxDecoration(
        color: Colors.black87, borderRadius: BorderRadius.circular(20)),
    child: Center(
        child: Text(
      text,
      style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 2),
    )),
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
    padding: const EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 170,
          width: 160,
          decoration: BoxDecoration(
              // color: Colors.amber,
              borderRadius: BorderRadius.circular(30)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              image,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return const Center(
                    // child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(productName.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: customTextStyle()),
            Text("₹$productPrice/-", style: customTextStyle())
          ],
        ),
        // ),
      ],
    ),
  );
}

Widget categoriesItems(
    {required double screenWidth,
    required double screenHeight,
    required BuildContext context,
    required className,
    required String categoryName,
    required String image,
    Color? color}) {
  return InkWell(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => className,
          ));
    },
    child: Stack(
      children: [
        Container(
          width: screenWidth,
          height: screenHeight * .17,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image:
                  DecorationImage(fit: BoxFit.cover, image: AssetImage(image))),
        ),
        Positioned(
            top: MediaQuery.of(context).size.height * .07,
            left: 30,
            child: Text(
              categoryName,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  color: Colors.black),
            ))
      ],
    ),
  );
}
