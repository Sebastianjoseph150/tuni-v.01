import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuni/screens/bottom_nav/pages/Home/pages_in_home_page/product_detail_page.dart';
import 'package:tuni/screens/bottom_nav/pages/caterory/categories_refactor.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

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
            _products;
      });
    } catch (error) {
      throw error.toString();
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
    return Platform.isAndroid
        ? Scaffold(
            appBar: AppBar(
              title: TextField(
                controller: _searchController,
                onChanged: _searchProducts,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
              ),
            ),
            body: _filteredProducts.isEmpty
                ? const Center(
                    child: Text('No products found.'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
          )
        : CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: CupertinoSearchTextField(
                controller: _searchController,
                onChanged: _searchProducts,
                keyboardType: TextInputType.text,
                // placeholder: "Search",
                // decoration: const InputDecoration(
                //   hintText: 'Search...',
                //   border: InputBorder.none,
                // ),
              ),
              trailing: const SizedBox(),
            ),

            child: _filteredProducts.isEmpty
                ? const Center(
                    child: Text('No products found.'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .72,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return GestureDetector(
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
                  ));
  }
}
