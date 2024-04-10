part of 'cart_bloc.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {}

class CartDataFetchedState extends CartState {
  final List<CartModel> cartDataList;
  final int cartTotalPrice;

  CartDataFetchedState({required this.cartDataList, required this.cartTotalPrice});
}

class CartItemDeletedState extends CartState {}

class CartActionSuccessState extends CartState {}

class RazorPaymentSuccessState extends CartState {}

class RazorPaymentFailedState extends CartState {}

class OrderedItemCancelledState extends CartState {}
