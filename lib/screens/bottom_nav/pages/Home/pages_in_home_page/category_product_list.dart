import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuni/screens/bottom_nav/pages/Home/pages_in_home_page/product_detail_page.dart';
import 'package:tuni/screens/bottom_nav/pages/caterory/categories_refactor.dart';

class CategoryProductList extends StatelessWidget {
  final Stream<QuerySnapshot<Object?>> firestore;
  final String heading;

  const CategoryProductList(
      {super.key, required this.firestore, required this.heading});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          heading.toUpperCase(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
          ),
        ),
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return const SizedBox(
                      height: 500,
                      child: Center(
                        child: Text(
                          "Coming soon...",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 0.75),
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
                      final List size = snapshot.data!.docs[index]["size"];
                      return InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailPage(productId: productId,
                                      productName: productName,
                                      imageUrl: imageUrlList,
                                      color: color,
                                      brand: brand,
                                      price: price,
                                      size: size,
                                      category: category,
                                      gender: gender,
                                      time: time),));
                          },
                          child: productView(productName, productPrice, imageUrl));
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
