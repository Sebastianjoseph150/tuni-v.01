import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tuni/screens/bottom_nav/pages/caterory/categories_refactor.dart';
import '../../Home/pages_in_home_page/product_detail_page.dart';

class AllCategory extends StatelessWidget {
  AllCategory({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final firestore =
        FirebaseFirestore.instance.collection('Clothes').snapshots();
    //
    // String productId;
    // String productName;
    // String productPrice;
    // List<dynamic> imageUrlList;
    // String imageUrl;
    // String color;
    // String brand;
    // String price;
    // String gender;
    // String category;
    // String time;
    // List size;

    return Platform.isAndroid
        ? Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.black,
              title: const Text(
                'All',
                style: TextStyle(letterSpacing: 3, fontSize: 20),
              ),
              toolbarHeight: 60,
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: firestore,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const SizedBox(
                    height: 500,
                    child: Center(
                      child: Text("Currently this category not available"),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Some Error Occurred'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: .72),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final productId = snapshot.data!.docs[index]["id"];
                    final productName = snapshot.data!.docs[index]["name"];
                    final productPrice = snapshot.data!.docs[index]["price"];
                    final imageUrl = snapshot.data!.docs[index]["imageUrl"][0];
                    final imageUrlList = snapshot.data!.docs[index]["imageUrl"];
                    final color = snapshot.data!.docs[index]["color"];
                    final brand = snapshot.data!.docs[index]["brand"];
                    final price = snapshot.data!.docs[index]["price"];
                    final gender = snapshot.data!.docs[index]["gender"];
                    final category = snapshot.data!.docs[index]["category"];
                    final time = snapshot.data!.docs[index]["time"];
                    List size = snapshot.data!.docs[index]["size"];
                    return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailPage(
                                    productId: productId,
                                    productName: productName,
                                    imageUrl: imageUrlList,
                                    color: color,
                                    brand: brand,
                                    price: price,
                                    size: size,
                                    category: category,
                                    gender: gender,
                                    time: time),
                              ));
                        },
                        child:
                            productView(productName, productPrice, imageUrl));
                  },
                );
              },
            ))
        : CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
              middle: Text("ALL COLLECTIONS"),
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const SizedBox(
                    height: 500,
                    child: Center(
                      child: Text("Currently this category not available"),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Some Error Occurred'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: .72,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 170,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        );
                      },
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: .72),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final productId = snapshot.data!.docs[index]["id"];
                    final productName = snapshot.data!.docs[index]["name"];
                    final productPrice = snapshot.data!.docs[index]["price"];
                    final imageUrl = snapshot.data!.docs[index]["imageUrl"][0];
                    final imageUrlList = snapshot.data!.docs[index]["imageUrl"];
                    final color = snapshot.data!.docs[index]["color"];
                    final brand = snapshot.data!.docs[index]["brand"];
                    final price = snapshot.data!.docs[index]["price"];
                    final gender = snapshot.data!.docs[index]["gender"];
                    final category = snapshot.data!.docs[index]["category"];
                    final time = snapshot.data!.docs[index]["time"];
                    List size = snapshot.data!.docs[index]["size"];
                    return GestureDetector(
                        onTap: () {
                          debugPrint(imageUrlList.toString());
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => ProductDetailPage(
                                    productId: productId,
                                    productName: productName,
                                    imageUrl: imageUrlList,
                                    color: color,
                                    brand: brand,
                                    price: price,
                                    size: size,
                                    category: category,
                                    gender: gender,
                                    time: time),
                              ));
                        },
                        child:
                            productView(productName, productPrice, imageUrl));
                  },
                );
              },
            ),
          );
  }
}

// Text(snapshot.data!.docs[index]['name']),
