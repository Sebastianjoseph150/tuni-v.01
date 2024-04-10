import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuni/model/address_model.dart';

class AddressRepository {
  final currentUser = FirebaseAuth.instance.currentUser;

  Future<List<AddressModel>> fetchAddressFromFirestore() async {
    if (currentUser != null) {
      final userId = currentUser!.uid;

      if (userId.isNotEmpty) {
        final QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('address')
            .get();
        return snapshot.docs.map((address) {
          return AddressModel(houseName: address['houseName'],
              city: address['city'],
              landMark: address['landMark'],
              pincode: address['pincode']);
        }).toList();
      }
    }

    return [];
  }
}
