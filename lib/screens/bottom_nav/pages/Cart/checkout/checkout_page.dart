// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../../bloc/cart_bloc/cart_bloc.dart';
import '../../../../../bloc/personal_details_bloc/personal_detail_bloc.dart';
import '../../../../../model/product_order_model.dart';
import '../../../bottom_navigation_bar/pages/bottom_nav_bar_page.dart';
import '../cart_refactor.dart';
import 'checkout_page_refactor.dart';

class CheckOutFromCartPage extends StatefulWidget {
  Map<String, dynamic> address = {};

  List<OrderModel> orderList;
  int total;

  CheckOutFromCartPage(
      {super.key,
      required this.address,
      required this.orderList,
      required this.total});

  @override
  State<CheckOutFromCartPage> createState() => _CheckOutFromCartPageState();
}

class _CheckOutFromCartPageState extends State<CheckOutFromCartPage> {
  Razorpay _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
  }



  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  final TextEditingController nameController = TextEditingController();

  final TextEditingController mobileNumberController = TextEditingController();

  final User user = FirebaseAuth.instance.currentUser!;

  int? selectedIndex;

  // int total = 0;

  @override
  Widget build(BuildContext context) {
    final userId = user.uid;
    final email = user.email ?? "";
    var firstName;
    var lastName;
    var mobile;
    // int calculateTotal(List<String> idList) {
    //   for (var item in cartItems) {
    //     int price = int.parse(item.price);
    //     int quantity = item.quantity;
    //     int totalPrice = price * quantity;
    //     total += totalPrice;
    //   }
    //   return total;
    // }

    // total = calculateTotal(widget.cartItem);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        if (state is RazorPaymentSuccessState) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Order Successful'),
                actions: [
                  TextButton.icon(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BottomNavBarPage(),
                            ),
                            (route) => false);
                      },
                      icon: Icon(Icons.home),
                      label: Text('Shop more'))
                ],
              );
            },
          );
        } else if (state is RazorPaymentFailedState) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BottomNavBarPage(),), (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                // total = widget.total;
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          title: Text(
            'CHECKOUT',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
            ),
          ),
          centerTitle: true,
          foregroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: screenWidth,
                height: screenHeight * .14,
                color: Colors.grey.shade200,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * .05,
                    top: screenHeight * .02,
                    right: screenWidth * .05,
                    bottom: screenHeight * .02,
                  ),
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .collection('personal_details')
                        .doc(email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Facing some error'),
                        );
                      } else if (!snapshot.hasData || !snapshot.data!.exists) {
                        return Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('No personal Details added'),
                            TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("PERSONAL DETAILS"),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              personalDetailsTextFormField(
                                                  controller: nameController,
                                                  hintText: 'Name'),
                                              SizedBox(height: 10),
                                              personalDetailsTextFormField(
                                                  controller:
                                                      mobileNumberController,
                                                  hintText: 'Mobile no.'),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'cancel',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              )),
                                          TextButton(
                                              onPressed: () {
                                                context
                                                    .read<PersonalDetailBloc>()
                                                    .add(OnAddPersonalDetailsEvent(
                                                        name:
                                                            nameController.text,
                                                        phone:
                                                            mobileNumberController
                                                                .text));
                                                Navigator.pop(context);
                                              },
                                              child: Text('Add')),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text('Add personal details')),
                          ],
                        ));
                      } else {
                        firstName = snapshot.data!.get('first_name');
                        lastName = snapshot.data!.get('last_name');
                        mobile = snapshot.data!.get('phone_number');
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            cartCheckoutSubHeadings(
                                headingName: 'MY INFORMATION'),
                            SizedBox(
                              height: screenHeight * .01,
                            ),
                            Text("$firstName $lastName"),
                            SizedBox(
                              height: screenHeight * .01,
                            ),
                            Text(email),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 15),
              CheckOutPageAddressView(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  address: widget.address),
              SizedBox(height: 15),
              CheckoutPageTotalPayableView(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  total: widget.total)
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                    height: 50,
                    width: screenWidth * .9,
                    child: ElevatedButton(
                        onPressed: () {
                          context.read<CartBloc>().add(RazorPayEvent(
                            context: context,
                                name: firstName,
                                email: user.email!,
                                mobile: mobile,
                                amount: widget.total,
                            orderList: widget.orderList,
                                address: widget.address,
                              ));
                        },
                        child: Text(
                          "RAZORPAY",
                          style: TextStyle(letterSpacing: 2),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))))),
              ],
            ),
          ),
          color: Colors.white,
        ),
      ),
    );
  }
}
