// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuni/screens/bottom_nav/pages/Cart/checkout/select_address.dart';
import 'package:tuni/screens/drawer/drawer.dart';

import '../../../../bloc/cart_bloc/cart_bloc.dart';
import '../../../../model/product_order_model.dart';

class CartPage extends StatefulWidget {
  CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int itemCount = 0;

  int total = 0;

  final User? user = FirebaseAuth.instance.currentUser;


  @override
  void dispose() {
    // productIds.clear();
    super.dispose();
  }
  List<OrderModel> productIds = [];


  @override
  Widget build(BuildContext context) {
    String userId = user!.uid;
    final firestore = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cartCollection')
        .snapshots();

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: DrawerWidget(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'CART',
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
          StreamBuilder<QuerySnapshot>(
              stream: firestore,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                // productIds.clear();
                total = 0;

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError)
                  return Center(child: Text("Some error occurred"));
                if (snapshot.data!.docs.isEmpty)
                  return Center(
                    child: SizedBox(
                      height: screenHeight * .52,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text('Your Cart is Empty')],
                      ),
                    ),
                  );
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final value = snapshot.data!.docs[index];
                    final String id = value['id'].toString();
                    final String image = value['image'][0].toString();
                    final String name = value['name'].toString();
                    final String size = value['size'].toString();
                    final String color = value['color'].toString();
                    final int price = int.parse(value['price']);
                    final int quantity = int.parse(value['itemCount']);

                    final int totalPrice = price * quantity;
                    total += totalPrice;
                    if (productIds.any((element) => element.productId == id)) {
                      final existingItemIndex = productIds
                          .indexWhere((element) => element.productId == id);

                      productIds[existingItemIndex].quantity = quantity;
                    } else {
                      productIds
                          .add(OrderModel(productId: id, quantity: quantity));
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      child: Container(
                        height: screenHeight * .169,
                        width: screenWidth,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                image,
                                fit: BoxFit.cover,
                                height: screenHeight * .15,
                                width: screenWidth * .25,
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: screenWidth * .6,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          name,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1),
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: Text(
                                                      "Remove this item from cart?"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("No")),
                                                    TextButton(
                                                        onPressed: () {
                                                          context
                                                              .read<CartBloc>()
                                                              .add(
                                                                  OnDeleteCartItem(
                                                                      id: id));
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            content: Text(
                                                                "Removed From Cart"),
                                                            duration: Duration(
                                                                milliseconds:
                                                                    1500),
                                                          ));
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("Yes"))
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text('Remove'))
                                    ],
                                  ),
                                ),
                                RichText(
                                    text: TextSpan(
                                        text: 'SIZE: ',
                                        style: TextStyle(color: Colors.black),
                                        children: [
                                      TextSpan(
                                          text: size,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500))
                                    ])),
                                RichText(
                                    text: TextSpan(
                                        text: 'COLOR: ',
                                        style: TextStyle(color: Colors.black),
                                        children: [
                                      TextSpan(
                                          text: color,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500))
                                    ])),
                                Spacer(),
                                SizedBox(
                                  width: screenWidth * .6,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '₹${price}/-',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1),
                                      ),
                                      BlocBuilder<CartBloc, CartState>(
                                        builder: (context, state) {
                                          itemCount =
                                              state is CartActionSuccessState
                                                  ? quantity
                                                  : quantity;
                                          return Container(
                                            width: 115,
                                            height: 35,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      context
                                                          .read<CartBloc>()
                                                          .add(
                                                              RemoveCartItemCountEvent(
                                                            itemId: id,
                                                          ));
                                                    },
                                                    icon: Icon(
                                                      Icons.remove,
                                                      size: 15,
                                                    )),
                                                Container(
                                                    child: Text(
                                                  itemCount.toString(),
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                )),
                                                IconButton(
                                                    onPressed: () {
                                                      context
                                                          .read<CartBloc>()
                                                          .add(
                                                              AddCartItemCountEvent(
                                                            itemId: id,
                                                          ));
                                                    },
                                                    icon: Icon(
                                                      Icons.add,
                                                      size: 15,
                                                    )),
                                              ],
                                            ),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black45),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(7))),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                // SizedBox(height: 10)
                              ],
                            ),
                          ]),
                        ),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 7,
                                offset: Offset(0, 2),
                              ),
                            ],
                            color: Colors.grey.shade100,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                      ),
                    );
                  },
                );
              }),
        ],
      )),
      bottomNavigationBar: StreamBuilder<QuerySnapshot>(
        stream: firestore,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isNotEmpty) {
              return BottomAppBar(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Your Cart total is ₹$total/-'),
                              content: Text("Proceed to checkout?"),
                              // content: Text(
                              //     'The total amount of your products is $total \n Go to checkout??'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('cancel',
                                      style: TextStyle(color: Colors.red)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SelectAddress(
                                          orderList: productIds,
                                          total: total,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('Go to checkout'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text("PROCEED TO CHECKOUT"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
                color: Colors.white,
              );
            }
          }
          return SizedBox();
        },
      ),
    );
  }
}
