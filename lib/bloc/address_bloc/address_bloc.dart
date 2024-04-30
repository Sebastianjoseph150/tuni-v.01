import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../screens/drawer/pages_in_drawer/shipping_address/address_repository.dart';

part 'address_event.dart';

part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final user = FirebaseAuth.instance.currentUser;

  AddressRepository addressRepository = AddressRepository();

  AddressBloc() : super(AddressInitial()) {
    on<OnAddAddressEvent>(onAddAddressEvent);
    on<OnEditAddressEvent>(onEditAddressEvent);
    on<OnDeleteAddressEvent>(onDeleteAddressEvent);
  }

  FutureOr<void> onAddAddressEvent(OnAddAddressEvent event,
      Emitter<AddressState> emit) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userId = currentUser.uid;
        final String id = DateTime
            .now()
            .millisecondsSinceEpoch
            .toString();
        CollectionReference collectionReference = FirebaseFirestore
            .instance
            .collection('users')
            .doc(userId)
            .collection('address');
        await collectionReference.doc(id).set({
          "id": id,
          "houseName": event.houseName,
          "city": event.city,
          "landmark": event.landMark,
          "pincode": event.pincode,
        });
        emit(AddressAddedState());
      }
    } catch (e) {
      throw e.toString();
    }
  }

  FutureOr<void> onEditAddressEvent(OnEditAddressEvent event,
      Emitter<AddressState> emit) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userId = currentUser.uid;
        await FirebaseFirestore.instance.collection('users').doc(userId)
            .collection('address').doc(event.addressId)
            .update({
          "houseName": event.houseName,
          "city": event.city,
          "landmark": event.landMark,
          "pincode": event.pincode,

        });
        emit(AddressUpdatedState());
      }
    } catch (e) {
      throw e.toString();
    }
  }


  FutureOr<void> onDeleteAddressEvent(OnDeleteAddressEvent event,
      Emitter<AddressState> emit) async {
    try {
      String userId = user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(userId)
          .collection('address').doc(event.addressId)
          .delete();
      emit(AddressDeletedState());
    } catch (e) {
      return;
    }
  }


}
