import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tuni/screens/drawer/pages_in_drawer/my_orders/ordered_product_detail.dart';

class OrderDetailPage extends StatelessWidget {
  final String orderId;

  OrderDetailPage({Key? key, required this.orderId}) : super(key: key);

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final userId = user!.uid;
    final firestore =
        FirebaseFirestore.instance.collection("AllOrdersList").snapshots();
    final stream = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("orderList")
        .doc(orderId)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          orderId,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        foregroundColor: Colors.black,
      ),
      body: StreamBuilder(
        stream: firestore,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text("No data available"),
            );
          }
          return StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {
              final productIds;
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                productIds = snapshot.data!.get("productId");
              }
              final address = snapshot.data!.get("address");
              final name = snapshot.data!.get("userName");
              final email = snapshot.data!.get("email");
              final number = snapshot.data!.get("phone");

              return ListView.builder(
                itemCount: productIds.length,
                itemBuilder: (context, index) {
                  final productId = productIds[index]["productId"];
                  final quantity = productIds[index]["quantity"];
                  final clothStream = FirebaseFirestore.instance
                      .collection("Clothes")
                      .doc(productId)
                      .snapshots();
                  return StreamBuilder<DocumentSnapshot>(
                    stream: clothStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return Center(
                          child: Text("No data available"),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error}"),
                        );
                      }
                      final productName = snapshot.data!.get("name");
                      final price = snapshot.data!.get("price");
                      final houseName = address["houseName"];
                      final city = address["city"];
                      final landmark = address["landmark"];
                      final pincode = address["pincode"];
                      final imageUrl =
                          List<String>.from(snapshot.data!.get("imageUrl"));
                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderedProductDetail(
                                      imageUrl: imageUrl,
                                      productName: productName,
                                      price: price,
                                      houseName: houseName,
                                      landmark: landmark,
                                      pincode: pincode,
                                      place: city,
                                      name: name,
                                      email: email,
                                      number: number,
                                      quantity: quantity,
                                    ),
                                  ));
                            },
                            leading: Container(
                              width: 50,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl[0]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(productName),
                            subtitle: Text("₹$price/-"),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
