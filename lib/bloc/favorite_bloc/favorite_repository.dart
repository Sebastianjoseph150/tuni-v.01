import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>>? _favoriteCollection;
  final User? user = FirebaseAuth.instance.currentUser;

  Future<bool> isFavorite({required String productId}) async {
    if (user != null) {
      final userId = user!.uid;
      _favoriteCollection = _firestore.collection('users').doc(userId).collection('favorite');
    }
    if (_favoriteCollection != null) {
      try {
        final doc = await _favoriteCollection!.doc(productId).get();
        debugPrint("isFavorite Function: ${doc.exists.toString()}");
        return doc.exists;
      } catch (e) {
        throw e.toString();
      }
    } else {
      return false;
    }
  }

  Future<void> addToFavorites({required String productId,
    required String name,
    required dynamic imageUrl,
    required String brand,
    required String price,
    required String category,
    required String gender,
    required String time,
    required List size
  }) async {

    debugPrint("image url adding to firebase :${imageUrl.toString()}");
    if(_favoriteCollection != null) {
      try {
        await _favoriteCollection!.doc(productId).set({
          "id": productId,
          "name": name,
          "imageUrl": imageUrl,
          "brand": brand,
          "price": price,
          "category": category,
          "gender": gender,
          "time": time,
          "color": time,
          "size": size
        });
      } catch (e) {
        throw e.toString();
      }
    }
  }

  Future<void> removeFromFavorites(String productId) async {
    if(_favoriteCollection != null) {
      try {
        await _favoriteCollection!.doc(productId).delete();
      } catch (e) {
        throw e.toString();
      }
    }
  }
}
