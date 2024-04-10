import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// import 'package:meta/meta.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:tuni/bloc/cart_bloc/cart_repository.dart';

import '../../../../../model/cart_model.dart';
import '../../model/product_order_model.dart';
import '../../screens/bottom_nav/bottom_navigation_bar/pages/bottom_nav_bar_page.dart';

part 'cart_event.dart';

part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartRepository cartRepository = CartRepository();

  final User? user = FirebaseAuth.instance.currentUser;
  Razorpay _razorpay = Razorpay();

  int totalAmount = 0;

  CartBloc() : super(CartInitial()) {
    on<FetchCartDataEvent>(fetchCartDataEvent);
    on<OnDeleteCartItem>(onDeleteCartItem);
    on<AddCartItemCountEvent>(addCartItemCountEvent);
    on<RemoveCartItemCountEvent>(removeCartItemCountEvent);
    // on<GetTotalProductPrice>(getTotalProductPrice);
    // on<RazorPayEventListenersEvent>(razorPayEventListenersEvent);
    on<RazorPayEvent>(razorPayEvent);
    on<CancelOrderedProductEvent>(cancelOrderedProductEvent);
  }

  FutureOr<void> fetchCartDataEvent(
      FetchCartDataEvent event, Emitter<CartState> emit) async {
    try {
      final int total = await cartRepository.getCartTotal();
      final List<CartModel> cartDataList =
          await cartRepository.fetchCartDataFromFirestore();
      emit(CartDataFetchedState(
          cartDataList: cartDataList, cartTotalPrice: total));
    } catch (e) {
      throw e.toString();
    }
  }

  FutureOr<void> onDeleteCartItem(
      OnDeleteCartItem event, Emitter<CartState> emit) async {
    try {
      await cartRepository.deleteCartItem(event.id);
      emit(CartItemDeletedState());
      final int total = await cartRepository.getCartTotal();
      final List<CartModel> cartDataList =
          await cartRepository.fetchCartDataFromFirestore();
      emit(CartDataFetchedState(
          cartDataList: cartDataList, cartTotalPrice: total));
    } catch (e) {
      throw e.toString();
    }
  }

  FutureOr<void> addCartItemCountEvent(
      AddCartItemCountEvent event, Emitter<CartState> emit) async {
    try {
      cartRepository.addCartItemCount(event.itemId);
      emit(CartActionSuccessState());
      int total = await cartRepository.getCartTotal();
      final List<CartModel> cartDataList =
          await cartRepository.fetchCartDataFromFirestore();
      emit(CartDataFetchedState(
          cartDataList: cartDataList, cartTotalPrice: total));
    } catch (e) {
      throw e.toString();
    }
  }

  FutureOr<void> removeCartItemCountEvent(
      RemoveCartItemCountEvent event, Emitter<CartState> emit) async {
    try {
      cartRepository.lessCartItemCount(event.itemId);
      emit(CartActionSuccessState());
      int total = await cartRepository.getCartTotal();
      final List<CartModel> cartDataList =
          await cartRepository.fetchCartDataFromFirestore();
      emit(CartDataFetchedState(
          cartDataList: cartDataList, cartTotalPrice: total));
    } catch (e) {
      throw e.toString();
    }
  }

  // FutureOr<void> getTotalProductPrice(GetTotalProductPrice event,
  //     Emitter<CartState> emit) async {
  //   final firestore = await
  // }

  FutureOr<void> razorPayEventListenersEvent(
      RazorPayEventListenersEvent event, Emitter<CartState> emit) async {}

  FutureOr<void> razorPayEvent(
      RazorPayEvent event, Emitter<CartState> emit) async {
    try {
      Map<String, dynamic> options = {
        'key': 'rzp_test_TpsHVKhrkZuIUJ',
        'amount': event.amount * 100,
        'name': 'Saiful Hamid A K',
        'description': 'demo',
        'timeout': 300,
        'prefill': {'contact': '7591926222', 'email': 'saifulhamid@gmail.com'}
      };
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
          (PaymentSuccessResponse response) {
        cartRepository.addOrderListInFirestore(
            context: event.context,
            name: event.name,
            email: event.email,
            address: event.address,
            mobile: event.mobile,
            orderList: event.orderList);

      });

      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
          (PaymentFailureResponse response) {
        Navigator.pushAndRemoveUntil(
            event.context,
            MaterialPageRoute(
              builder: (context) => BottomNavBarPage(),
            ),
            (route) => false);
        showDialog(
          context: event.context,
          builder: (context) {
            return AlertDialog(
              content: Text("Can't checkout, please try again!!"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK"))
              ],
            );
          },
        );
      });

      _razorpay.on(
          Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse response) {});
      _razorpay.open(options);
    } catch (e) {
      throw e.toString();
    }
  }

  FutureOr<void> cancelOrderedProductEvent(
      CancelOrderedProductEvent event, Emitter<CartState> emit) async {
    try {
      final userId = user!.uid;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("orderList")
          .doc(event.orderId)
          .delete();
      await FirebaseFirestore.instance
          .collection("AllOrderList")
          .doc(event.orderId)
          .delete();
    } catch (e) {
      throw e.toString();
    }
  }
}
