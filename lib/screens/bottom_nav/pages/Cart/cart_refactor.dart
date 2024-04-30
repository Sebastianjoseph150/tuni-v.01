import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/cart_bloc/cart_bloc.dart';
import '../../../../model/product_order_model.dart';

Widget cartCheckoutSubHeadings({
  required String headingName,
}) {
  return Text(
    headingName,
    style: const TextStyle(
        letterSpacing: 1.5, fontSize: 16, fontWeight: FontWeight.w500),
  );
}

Widget personalDetailsTextFormField(
    {required TextEditingController controller, required String hintText}) {
  return SizedBox(
    height: 50,
    child: Platform.isAndroid? TextFormField(
      controller: controller,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10)),
          hintText: hintText,
          filled: true,
          fillColor: Colors.grey.shade100,
          labelText: hintText),
    ): CupertinoTextField(
      controller: controller,
      placeholder: hintText,
    ),
  );
}

Widget richTextInCheckout({required String content, required String text}) {
  return RichText(
    text: TextSpan(
        text: '$content: ',
        children: [
          TextSpan(
              text: text.toUpperCase(),
              style: const TextStyle(color: Colors.black))
        ],
        style: const TextStyle(color: Colors.black, letterSpacing: 0.5)),
  );
}

StreamBuilder<QuerySnapshot<Object?>> cartItemsListingRefactor(
    {required Stream<QuerySnapshot<Map<String, dynamic>>> firestore,
    required double screenHeight,
    required double screenWidth,
    required dynamic total,
    required dynamic productIds,
    required dynamic itemCount}) {
  return StreamBuilder<QuerySnapshot>(
      stream: firestore,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        total = 0;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: Platform.isAndroid
                  ? const CircularProgressIndicator()
                  : const CupertinoActivityIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Some error occurred"));
        }
        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: SizedBox(
              height: screenHeight * .52,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Your Cart is Empty')],
              ),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
              final existingItemIndex =
                  productIds.indexWhere((element) => element.productId == id);

              productIds[existingItemIndex].quantity = quantity;
            } else {
              productIds.add(OrderModel(productId: id, quantity: quantity));
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Container(
                height: screenHeight * .169,
                width: screenWidth,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Platform.isAndroid
                            ? Colors.grey.withOpacity(0.1)
                            : CupertinoColors.systemGrey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    color: Platform.isAndroid
                        ? Colors.grey.shade100
                        : CupertinoColors.systemGrey6,
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
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
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: screenWidth * .6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1),
                                ),
                              ),
                              Platform.isAndroid
                                  ? TextButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: const Text(
                                                  "Remove this item from cart?"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("No")),
                                                TextButton(
                                                    onPressed: () {
                                                      context
                                                          .read<CartBloc>()
                                                          .add(OnDeleteCartItem(
                                                              id: id));
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                        content: Text(
                                                            "Removed From Cart"),
                                                        duration: Duration(
                                                            milliseconds: 1500),
                                                      ));
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("Yes"))
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: const Text('Remove'))
                                  : CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      child: const Text(
                                        "Remove",
                                        style: TextStyle(
                                            color: CupertinoColors.systemRed),
                                      ),
                                      onPressed: () {
                                        showCupertinoDialog(
                                          context: context,
                                          builder: (context) {
                                            return CupertinoAlertDialog(
                                              title:
                                                  const Text("Are you sure?"),
                                              content: const Text(
                                                  "Do you want to remove this item from cart?"),
                                              actions: [
                                                CupertinoDialogAction(
                                                  onPressed: () {
                                                    Navigator.pop(context,
                                                        false);
                                                  },
                                                  child: const Text(
                                                    "No",
                                                    style: TextStyle(
                                                        color: CupertinoColors
                                                            .systemRed),
                                                  ),
                                                ),
                                                CupertinoDialogAction(
                                                  onPressed: () {
                                                    context
                                                        .read<CartBloc>()
                                                        .add(OnDeleteCartItem(
                                                            id: id));
                                                    Navigator.pop(
                                                        context, true);
                                                  },
                                                  child: const Text("Yes"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      })
                            ],
                          ),
                        ),
                        RichText(
                            text: TextSpan(
                                text: 'SIZE: ',
                                style: TextStyle(
                                    color: Platform.isAndroid
                                        ? Colors.black
                                        : CupertinoColors.black),
                                children: [
                              TextSpan(
                                  text: size,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500))
                            ])),
                        RichText(
                            text: TextSpan(
                                text: 'COLOR: ',
                                style: TextStyle(
                                    color: Platform.isAndroid
                                        ? Colors.black
                                        : CupertinoColors.black),
                                children: [
                              TextSpan(
                                  text: color,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500))
                            ])),
                        const Spacer(),
                        SizedBox(
                          width: screenWidth * .6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '₹$price/-',
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1),
                              ),
                              BlocBuilder<CartBloc, CartState>(
                                builder: (context, state) {
                                  itemCount = state is CartActionSuccessState
                                      ? quantity
                                      : quantity;
                                  return Container(
                                    width: 115,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Platform.isAndroid
                                                ? Colors.black
                                                : CupertinoColors.black),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(7))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Platform.isAndroid
                                            ? IconButton(
                                                onPressed: () {
                                                  context.read<CartBloc>().add(
                                                          RemoveCartItemCountEvent(
                                                        itemId: id,
                                                      ));
                                                },
                                                icon: const Icon(
                                                  Icons.remove,
                                                  size: 15,
                                                ))
                                            : CupertinoButton(
                                                padding: EdgeInsets.zero,
                                                child: const Icon(
                                                  CupertinoIcons.minus,
                                                  size: 15,
                                                ),
                                                onPressed: () {
                                                  context.read<CartBloc>().add(
                                                          RemoveCartItemCountEvent(
                                                        itemId: id,
                                                      ));
                                                }),
                                        Text(
                                          itemCount.toString(),
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                        Platform.isAndroid
                                            ? IconButton(
                                                onPressed: () {
                                                  context.read<CartBloc>().add(
                                                          AddCartItemCountEvent(
                                                        itemId: id,
                                                      ));
                                                },
                                                icon: const Icon(
                                                  Icons.add,
                                                  size: 15,
                                                ))
                                            : CupertinoButton(
                                                padding: EdgeInsets.zero,
                                                child: const Icon(
                                                  CupertinoIcons.add,
                                                  size: 15,
                                                ),
                                                onPressed: () {
                                                  context.read<CartBloc>().add(
                                                          AddCartItemCountEvent(
                                                        itemId: id,
                                                      ));
                                                }),
                                      ],
                                    ),
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
              ),
            );
          },
        );
      });
}
