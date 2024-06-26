import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tuni/screens/drawer/drawer.dart';
import 'favorite_refactor.dart';

class FavoritePage extends StatelessWidget {
  FavoritePage({Key? key}) : super(key: key);

  final User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    // final screenWidth = MediaQuery
    //     .of(context)
    //     .size
    //     .width;
    final userId = user.uid;
    final firestore = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorite')
        .snapshots();

    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text(
          'FAVORITES',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
          ),
        ),
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FavoriteItemsGridView(firestore: firestore, screenHeight: screenHeight),
      ),
    );
  }
}

