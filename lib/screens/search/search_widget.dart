import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuni/screens/bottom_nav/pages/Home/pages_in_home_page/product_detail_page.dart';
import 'package:tuni/screens/bottom_nav/pages/caterory/categories_refactor.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _products = [];
  List<DocumentSnapshot> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("Clothes").get();
      setState(() {
        _products = snapshot.docs;
        _filteredProducts =
            _products; // Initialize filtered products with all products
      });
    } catch (error) {
      print("Error fetching products: $error");
    }
  }

  void _searchProducts(String query) {
    setState(() {
      _filteredProducts = _products.where((product) {
        final productName = product['name'].toString().toLowerCase();
        return productName.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _searchProducts,
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: _filteredProducts.isEmpty
          ? Center(
              child: Text('No products found.'),
            )
          : GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .72,
              ),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(
                          productId: product['id'],
                          productName: product['name'],
                          imageUrl: product['imageUrl'],
                          color: product['color'],
                          brand: product['brand'],
                          price: product['price'],
                          size: List<String>.from(product['size']),
                          category: product['category'],
                          gender: product['gender'],
                          time: product['time'],
                        ),
                      ),
                    );
                  },
                  child: productView(
                    product['name'],
                    product['price'],
                    product['imageUrl'][0],
                  ),
                );
              },
            ),
    );
  }
}
