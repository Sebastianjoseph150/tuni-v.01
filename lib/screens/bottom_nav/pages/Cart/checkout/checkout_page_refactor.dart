
import 'package:flutter/material.dart';
import '../cart_refactor.dart';

// class CheckoutPageRazorPayButton extends StatelessWidget {
//   CheckoutPageRazorPayButton({
//     super.key,
//     required this.screenWidth,
//     required this.name,
//     required this.user,
//     required this.mobile,
//     required this.total,
//     required this.orderList,
//     required this.address,
//   });
//
//   final double screenWidth;
//   final name;
//   final User user;
//   final mobile;
//   final int total;
//   final List<OrderModel> orderList;
//   final Map<String, dynamic> address;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           SizedBox(
//               height: 50,
//               width: screenWidth * .9,
//               child: ElevatedButton(
//                   onPressed: () {
//                     // context.read<CartBloc>().add(RazorPayEvent(
//                     //   name: name,
//                     //   email: user.email!,
//                     //   mobile: mobile,
//                     //   amount: total,
//                     //   orderList: orderList,
//                     //   address: address,
//                     // ));
//                   },
//                   child: Text(
//                     "RAZORPAY",
//                     style: TextStyle(letterSpacing: 2),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blueGrey,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15))))),
//         ],
//       ),
//     );
//   }
// }

class CheckoutPageTotalPayableView extends StatelessWidget {
  const CheckoutPageTotalPayableView({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.total,
  });

  final double screenHeight;
  final double screenWidth;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      height: screenHeight * .13,
      child: Padding(
        padding: EdgeInsets.only(
          left: screenWidth * .05,
          top: screenHeight * .02,
          right: screenWidth * .05,
          bottom: screenHeight * .02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cartCheckoutSubHeadings(headingName: "TOTAL PAYABLE"),
            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total amount to pay: '),
                Text(
                  '₹${total.toString()}/-',
                  style: const TextStyle(
                      letterSpacing: 1.5,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CheckOutPageAddressView extends StatelessWidget {
  const CheckOutPageAddressView({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.address,
  });

  final double screenHeight;
  final double screenWidth;
  final Map<String, dynamic> address;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      height: screenHeight * .22,
      width: screenWidth,
      child: Padding(
        padding: EdgeInsets.only(
          left: screenWidth * .05,
          top: screenHeight * .02,
          right: screenWidth * .05,
          bottom: screenHeight * .02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cartCheckoutSubHeadings(headingName: 'ADDRESS'),
            const SizedBox(height: 15),
            richTextInCheckout(
                content: 'House Name', text: address['houseName']),
            const SizedBox(height: 10),
            richTextInCheckout(
                content: 'Place', text: address['city'] ?? ''),
            const SizedBox(height: 10),
            richTextInCheckout(
                content: 'Landmark', text: address['landmark'] ?? ''),
            const SizedBox(height: 10),
            richTextInCheckout(
                content: 'Pin code', text: address['pincode'] ?? ''),
          ],
        ),
      ),
    );
  }
}