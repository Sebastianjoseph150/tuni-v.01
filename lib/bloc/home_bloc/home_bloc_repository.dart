import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/product_model.dart';

class HomeRepository {
  final CollectionReference dataCollection =
      FirebaseFirestore.instance.collection("Clothes");

  final user = FirebaseAuth.instance.currentUser;
  CollectionReference<Map<String, dynamic>>? favoriteCollection;

  Future<List<Product>> fetchDataFromFirestore() async {
    QuerySnapshot snapshot = await dataCollection.get();
    return snapshot.docs.map((product) {
      return Product(
        id: product['id'],
        name: product['name'],
        gender: product['gender'],
        category: product['category'],
        brand: product['brand'],
        price: product['price'],
        imageUrl: product['imageUrl'] ?? '',
        time: product['time'],
        size: product['size'],
        quantity: product['Quantity'] ?? 0,
        color: product['color'],
      );
    }).toList();
  }

  Future<void> addProductToCart({
    required String id,
    required String name,
    required List image,
    required String price,
    required String color,
    required String itemCount,
    required String selectedSize,
  }) async {
    final userId = user?.uid;
    CollectionReference users = FirebaseFirestore.instance.collection("users");
    Map<String, dynamic> cartData = {
      "id": id,
      "image": image,
      "name": name,
      "price": price,
      "color": color,
      "itemCount": itemCount,
      "size": selectedSize
    };
    users.doc(userId).collection("cartCollection").doc(id).set(cartData);
  }
}
