import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../Home/pages_in_home_page/product_detail_page.dart';
import '../categories_refactor.dart';

class MenCategory extends StatelessWidget {
  MenCategory({super.key});

  final firestore = FirebaseFirestore.instance
      .collection('Clothes')
      .where('gender', isEqualTo: 'Men')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    String productId;
    String productName;
    String productPrice;
    List<dynamic> imageUrlList;
    String imageUrl;
    String color;
    String brand;
    String price;
    String gender;
    String category;
    String time;
    List size;
    return Platform.isAndroid
        ? Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.black,
              title: const Text(
                'MEN',
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
                    productId = snapshot.data!.docs[index]["id"];
                    productName = snapshot.data!.docs[index]["name"];
                    productPrice = snapshot.data!.docs[index]["price"];
                    imageUrl = snapshot.data!.docs[index]["imageUrl"][0];
                    imageUrlList = snapshot.data!.docs[index]["imageUrl"];
                    color = snapshot.data!.docs[index]["color"];
                    brand = snapshot.data!.docs[index]["brand"];
                    price = snapshot.data!.docs[index]["price"];
                    gender = snapshot.data!.docs[index]["gender"];
                    category = snapshot.data!.docs[index]["category"];
                    time = snapshot.data!.docs[index]["time"];
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
              middle: Text("COLLECTIONS FOR MEN"),
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
                    baseColor: CupertinoColors.systemGrey,
                    highlightColor: CupertinoColors.systemGrey,
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
                            color: CupertinoColors.white,
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
                    productId = snapshot.data!.docs[index]["id"];
                    productName = snapshot.data!.docs[index]["name"];
                    productPrice = snapshot.data!.docs[index]["price"];
                    imageUrl = snapshot.data!.docs[index]["imageUrl"][0];
                    imageUrlList = snapshot.data!.docs[index]["imageUrl"];
                    color = snapshot.data!.docs[index]["color"];
                    brand = snapshot.data!.docs[index]["brand"];
                    price = snapshot.data!.docs[index]["price"];
                    gender = snapshot.data!.docs[index]["gender"];
                    category = snapshot.data!.docs[index]["category"];
                    time = snapshot.data!.docs[index]["time"];
                    size = snapshot.data!.docs[index]["size"];
                    return GestureDetector(
                        onTap: () {
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
