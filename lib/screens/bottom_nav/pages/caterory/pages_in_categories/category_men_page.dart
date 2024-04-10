import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Home/pages_in_home_page/product_detail_page.dart';
import '../categories_refactor.dart';

class MenCategory extends StatelessWidget {
  MenCategory({super.key});

  final firestore =
  FirebaseFirestore.instance.collection('Clothes').where('gender', isEqualTo: 'Men').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Text(
          'MEN',
          style: TextStyle(letterSpacing: 3, fontSize: 20),
        ),
        toolbarHeight: 60,
      ),
      body:  StreamBuilder<QuerySnapshot>(
        stream: firestore,
        builder: (context, snapshot) {
          if(!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return SizedBox(height: 500,
              child: Center(child:  Text("Currently this category not available"),),);
          }
          if(snapshot.hasError) {
            return Center(
              child: Text('Some Error Occurred'),
            );
          }
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center( child: CircularProgressIndicator(),);
          }
          return GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
      )
    );
  }
}
