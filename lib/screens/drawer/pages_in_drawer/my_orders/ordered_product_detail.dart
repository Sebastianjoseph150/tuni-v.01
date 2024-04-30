import 'package:flutter/material.dart';
import 'my_orders_refactor.dart';

class OrderedProductDetail extends StatelessWidget {
  final List imageUrl;
  final String productName;
  final String price;
  final String name;
  final String number;
  final String email;
  final String houseName;
  final String place;
  final String landmark;
  final String pincode;
  final int quantity;

  const OrderedProductDetail(
      {super.key,
      required this.name,
      required this.number,
      required this.email,
      required this.imageUrl,
      required this.productName,
      required this.price,
      required this.houseName,
      required this.pincode,
      required this.landmark,
      required this.place,
      required this.quantity
      });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            OrderedDetailPageCarouselSlider(
                imageUrl: imageUrl,
                screenHeight: screenHeight,
                screenWidth: screenWidth),
            SizedBox(height: screenHeight * .02),
            OtherDetailsInOrderDetailPage(
                productName: productName,
                price: price,
                screenHeight: screenHeight,
                name: name,
                number: number,
                email: email,
                houseName: houseName,
                place: place,
                landmark: landmark,
                pincode: pincode,
              quantity: quantity,

            ),
          ],
        ),
      )),
    );
  }
}
