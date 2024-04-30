import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class OtherDetailsInOrderDetailPage extends StatelessWidget {
  const OtherDetailsInOrderDetailPage(
      {super.key,
      required this.productName,
      required this.price,
      required this.screenHeight,
      required this.name,
      required this.number,
      required this.email,
      required this.houseName,
      required this.place,
      required this.landmark,
      required this.pincode,
      required this.quantity});

  final String productName;
  final String price;
  final double screenHeight;
  final String name;
  final String number;
  final String email;
  final String houseName;
  final String place;
  final String landmark;
  final String pincode;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    productName.toUpperCase(),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2),
                  ),
                  Text(
                    '₹$price/-',
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * .02),
              AddressTextSpanOrderedDetailPage(
                  heading: "Ordered Quantity", text: quantity.toString()),
              SizedBox(height: screenHeight * .02),
              Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
              const Text(
                "Details: ",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                    fontSize: 18),
              ),
              SizedBox(height: screenHeight * .01),
              AddressTextSpanOrderedDetailPage(heading: "Name", text: name),
              SizedBox(height: screenHeight * .01),
              AddressTextSpanOrderedDetailPage(
                  heading: "mobile", text: number),
              SizedBox(height: screenHeight * .01),
              AddressTextSpanOrderedDetailPage(
                  heading: "email", text: email),
                              ],
                            ),
              SizedBox(height: screenHeight * .02),
              Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
              const Text(
                "Address: ",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                    fontSize: 18),
              ),
              SizedBox(height: screenHeight * .01),
              AddressTextSpanOrderedDetailPage(
                  heading: "House Name", text: houseName),
              SizedBox(height: screenHeight * .01),
              AddressTextSpanOrderedDetailPage(
                  heading: "City", text: place),
              SizedBox(height: screenHeight * .01),
              AddressTextSpanOrderedDetailPage(
                  heading: "landmark", text: landmark),
              SizedBox(height: screenHeight * .01),
              AddressTextSpanOrderedDetailPage(
                  heading: "pincode", text: pincode),
                              ],
                            ),
            ],
          ),
        ),
      ],
    );
  }
}

class OrderedDetailPageCarouselSlider extends StatelessWidget {
  const OrderedDetailPageCarouselSlider({
    super.key,
    required this.imageUrl,
    required this.screenHeight,
    required this.screenWidth,
  });

  final List imageUrl;
  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        items: imageUrl.map((url) {
          return Builder(
            builder: (context) {
              return SizedBox(
                height: screenHeight,
                width: screenWidth,
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              );
            },
          );
        }).toList(),
        options:
            CarouselOptions(height: screenHeight * .5, viewportFraction: 1));
  }
}

class AddressTextSpanOrderedDetailPage extends StatelessWidget {
  const AddressTextSpanOrderedDetailPage({
    super.key,
    required this.text,
    required this.heading,
  });

  final String text;
  final String heading;

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            text: "$heading: ",
            style: const TextStyle(color: Colors.black, fontSize: 17),
            children: [
          TextSpan(
              text: text.toUpperCase(),
              style: const TextStyle(
                  color: Colors.black, fontSize: 17, letterSpacing: 1))
        ]));
  }
}
