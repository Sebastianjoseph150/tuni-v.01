import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../model/cart_model.dart';
import '../../model/product_order_model.dart';
import '../../screens/bottom_nav/bottom_navigation_bar/pages/bottom_nav_bar_page.dart';

class CartRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('users');
  final user = FirebaseAuth.instance.currentUser!;

  Future<List<CartModel>> fetchCartDataFromFirestore() async {
    final userId = user.uid;
    final DocumentReference userDoc = collection.doc(userId);
    final QuerySnapshot cartCollection =
        await userDoc.collection('cartCollection').get();

    List<CartModel> cartDataList = [];

    for (QueryDocumentSnapshot cartDoc in cartCollection.docs) {
      CartModel cartData =
          CartModel.fromMap(cartDoc.data() as Map<String, dynamic>);
      cartDataList.add(cartData);
    }
    return cartDataList;
  }

  Future<int> getCartTotal() async {
    final userId = user.uid;
    final QuerySnapshot<Map<String, dynamic>> cartTotal =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cartCollection')
            .get();

    int total = 0;
    for (QueryDocumentSnapshot documentSnapshot in cartTotal.docs) {
      final int priceTotal = int.parse(documentSnapshot['price']);
      final int quantityTotal = int.parse(documentSnapshot['itemCount']);

      final int totalProductPrice = priceTotal * quantityTotal;
      total += totalProductPrice;
    }
    debugPrint(total.toString());
    return total;
  }

  Future<void> deleteCartItem(String itemId) async {
    final userId = user.uid;
    // debugPrint(itemId);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cartCollection')
        .doc(itemId)
        .delete();
  }

  Future<void> addCartItemCount(String itemId) async {
    final userId = user.uid;
    DocumentReference firebaseCartCollection = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cartCollection')
        .doc(itemId);
    DocumentSnapshot documentSnapshot = await firebaseCartCollection.get();
    int itemCount = int.parse(documentSnapshot['itemCount']);
    int increasedCount = itemCount + 1;
    await firebaseCartCollection
        .update({"itemCount": increasedCount.toString()});
  }

  Future<void> lessCartItemCount(String itemId) async {
    final userId = user.uid;
    DocumentReference firebaseCartCollection = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cartCollection')
        .doc(itemId);
    DocumentSnapshot documentSnapshot = await firebaseCartCollection.get();
    int itemCount = int.parse(documentSnapshot['itemCount']);
    int increasedCount = itemCount - 1;
    if (increasedCount > 0) {
      await firebaseCartCollection
          .update({"itemCount": increasedCount.toString()});
    } else {
      deleteCartItem(itemId);
    }
  }


  Future<void> addOrderListInFirestore(
      {
      // required List<String> idList,
      required String name,
      required String email,
      required Map<dynamic, dynamic> address,
      required String mobile,
      required BuildContext context,
      required List<OrderModel> orderList}) async {
    final userId = user.uid;
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final orderId = "order_$id";
    final DocumentReference userDocument = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('orderList')
        .doc(orderId);
    // orderList.clear();
    debugPrint(orderList.toString());

    final DocumentReference allOrderDocument =
        FirebaseFirestore.instance.collection("AllOrderList").doc(orderId);

    final List<Map<String, dynamic>> orderMapList = orderList.map((order) {
      return {
        "productId": order.productId,
        "quantity": order.quantity,
      };
    }).toList();

    final orderDate = DateTime.now().toString();
    if (orderMapList.isNotEmpty) {
      await userDocument.set({
        "orderId": orderId,
        "productId": orderMapList,
        "orderDate": orderDate,
        "address": address,
        "userName": name,
        "email": email,
        "phone": mobile,
      });
      await allOrderDocument.set({
        "orderId": orderId,
        "productId": orderMapList,
        "orderDate": orderDate,
        "address": address,
        "userName": name,
        "email": email,
        "phone": mobile,
      });
    }

    // CollectionReference cartCollection = FirebaseFirestore.instance.collection("users").
    // doc(userId).collection("cartCollection");
    // QuerySnapshot querySnapshot = await cartCollection.get();
    // for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
    //   await documentSnapshot.reference.delete();
    // }

    for (OrderModel order in orderList) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cartCollection')
          .doc(order.productId)
          .delete();
    }
    orderList.clear();
    orderMapList.clear();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavBarPage(),
        ),
        (route) => false);
  }
}
