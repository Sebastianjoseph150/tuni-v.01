import 'package:flutter/material.dart';
import 'package:tuni/model/brand.dart';
import 'package:tuni/model/product_model.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../provider/category_provider.dart';

class Cat1 extends StatelessWidget {
  final String category;

  const Cat1({Key? key, this.category = "Tshirt"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return FutureBuilder<List<Product>>(
      future: _fetchProductsFromFirestore(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        List<Product> products = snapshot.data ?? [];

        return Consumer<CategorySelect>(
          builder: (context, categorySelect, _) {
            List<Product> filteredProducts = categorySelect.priceFilter(
              categorySelect.nameFilter(products, Brand(brandName: 'tuni')),
              500, // Example maximum price
            );

            return Container(
              width: mediaQuery.size.width,
              color: Colors.white,
              child: GridView.builder(
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _calculateCrossAxisCount(mediaQuery),
                  childAspectRatio: .72,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final Product product = filteredProducts[index];
                  return InkWell(
                    onTap: () {
                      // Handle onTap
                    },
                    child: productView(product),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  int _calculateCrossAxisCount(MediaQueryData mediaQuery) {
    double screenWidth = mediaQuery.size.width;
    double itemWidth = 170; // Width of each grid item
    int crossAxisCount = screenWidth ~/ itemWidth;
    return crossAxisCount;
  }

  Future<List<Product>> _fetchProductsFromFirestore() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('Clothes')
        .where('category', isEqualTo: category)
        .get();

    List<Product> products =
        querySnapshot.docs.map((doc) => Product.fromMap(doc.data())).toList();

    return products;
  }

  Widget productView(Product product) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 139,
            width: 170,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "₹${product.price}/-",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }
}
