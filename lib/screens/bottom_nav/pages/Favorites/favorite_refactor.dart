import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Home/pages_in_home_page/product_detail_page.dart';
import '../caterory/categories_refactor.dart';

Widget favoriteItems({required String image,required String text }) {
  return Padding(
    padding: const EdgeInsets.only(left: 5),
    child: Column(
      children: [
        Container(
          height: 170,
          width: 170,
          child: Container(
            child: ClipRect(child: Image.asset(image,fit: BoxFit.cover,)),
            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
          ),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            // color: Colors.teal,
            height: 80,
            width: 170,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                Text('₹ 1,990.00', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
              ],
            ),
          ),
        )
      ],
    ),
  );
}

class FavoriteItemsGridView extends StatelessWidget {
  const FavoriteItemsGridView({
    super.key,
    required this.firestore,
    required this.screenHeight,
  });

  final Stream<QuerySnapshot<Map<String, dynamic>>> firestore;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: SizedBox(
                  height: screenHeight * .52,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('No Favorite items')],
                  ),
                ),
              );
            }
            return GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: .72),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final String productName = snapshot.data!
                    .docs[index]['name'];
                final String productPrice = snapshot.data!
                    .docs[index]['price'];
                final String image = snapshot.data!.docs[index]['imageUrl'][index];
                final imageUrl = snapshot.data!.docs[index]['imageUrl'];
                final color = snapshot.data!.docs[index]['color'];
                final brand = snapshot.data!.docs[index]['brand'];
                final List size = snapshot.data!.docs[index]['size'];
                final category = snapshot.data!.docs[index]['category'];
                final gender = snapshot.data!.docs[index]['gender'];
                final time = snapshot.data!.docs[index]['time'];
                final productId = snapshot.data!.docs[index]['id'];

                return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailPage(productId: productId,
                                productName: productName,
                                imageUrl: imageUrl,
                                color: color,
                                brand: brand,
                                price: productPrice,
                                size: size,
                                category: category,
                                gender: gender,
                                time: time),));
                    },
                    child: productView(productName, productPrice, image));
              },
            );
          },
        ));
  }
}
