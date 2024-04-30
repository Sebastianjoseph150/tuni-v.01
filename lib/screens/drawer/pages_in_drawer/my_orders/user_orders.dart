import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tuni/screens/drawer/pages_in_drawer/my_orders/orders_detail.dart';
import '../../../../bloc/cart_bloc/cart_bloc.dart';

class UserOrders extends StatelessWidget {
  UserOrders({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

  String _parseDate(String dateString) {
    final dateTime = DateTime.parse(dateString);
    final formattedDate = DateFormat('dd-MM-yy').format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    final userId = user!.uid;
    final firestore = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("orderList")
        .snapshots();
    return Platform.isAndroid
        ? Scaffold(
            appBar: AppBar(
              title: const Text(
                'MY ORDERS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),
              centerTitle: true,
              foregroundColor: Colors.black,
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: firestore,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("You have no ordered anything"),
                  );
                }
                final reversedDoc = snapshot.data!.docs.reversed.toList();
                if (reversedDoc.isEmpty) {
                  return const Center(
                    child: Text('You have no ordered anything'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final orderId = reversedDoc[index]['orderId'];
                    final orderDateString =
                        reversedDoc[index]['orderDate'] as String;
                    final formattedDate = _parseDate(orderDateString);
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetailPage(orderId: orderId),
                            ));
                      },
                      child: ListTile(
                        leading: Text(formattedDate.toString()),
                        title: Text(orderId),
                        // subtitle: Text(houseName),
                        trailing: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: const Text(
                                        "Do you want to cancel this order?"),
                                    title: const Text("Are you sure?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            context.read<CartBloc>().add(
                                                CancelOrderedProductEvent(
                                                    orderId: orderId));
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Yes")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("No")),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            )),
                      ),
                    );
                  },
                );
              },
            ),
          )
        : CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
              middle: Text("Your Orders"),
            ),
            child: CupertinoScrollbar(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("You have no ordered anything"),
                    );
                  }
                  final reversedDoc = snapshot.data!.docs.reversed.toList();
                  if (reversedDoc.isEmpty) {
                    return const Center(
                      child: Text('You have no ordered anything'),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CupertinoActivityIndicator();
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final orderId = reversedDoc[index]['orderId'];
                      final orderDateString =
                          reversedDoc[index]['orderDate'] as String;
                      final formattedDate = _parseDate(orderDateString);
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    OrderDetailPage(orderId: orderId),
                              ));
                        },
                        child: CupertinoListTile(
                          leading: Text(formattedDate.toString()),
                          title: Text(orderId),
                          // subtitle: Text(houseName),
                          trailing: CupertinoButton(
                              onPressed: () {
                                showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      content: const Text(
                                          "Do you want to cancel this order?"),
                                      title: const Text("Are you sure?"),
                                      actions: [
                                        CupertinoDialogAction(
                                            onPressed: () {
                                              context.read<CartBloc>().add(
                                                  CancelOrderedProductEvent(
                                                      orderId: orderId));
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Yes")),
                                        CupertinoDialogAction(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("No")),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                    color: CupertinoColors.systemRed,
                                    fontSize: 12),
                              )),
                        ),
                      );
                    },
                  );
                },
              ),
            ));
  }
}
