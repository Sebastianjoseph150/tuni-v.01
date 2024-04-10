import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
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
            return Center(
              child: Text("You have no ordered anything"),
            );
          }
          final reversedDoc = snapshot.data!.docs.reversed.toList();
          if (reversedDoc.isEmpty) {
            return Center(
              child: Text('You have no ordered anything'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final orderId = reversedDoc[index]['orderId'];
              // final address = reversedDoc[index]['address'];
              final orderDateString = reversedDoc[index]['orderDate'] as String;
              final formattedDate = _parseDate(orderDateString);
              // final houseName = address['houseName'];
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailPage(orderId: orderId),
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
                              content:
                                  Text("Do you want to cancel this order?"),
                              title: Text("Are you sure?"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      context.read<CartBloc>().add(
                                          CancelOrderedProductEvent(
                                              orderId: orderId));
                                      Navigator.pop(context);
                                    },
                                    child: Text("Yes")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("No")),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      )),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
