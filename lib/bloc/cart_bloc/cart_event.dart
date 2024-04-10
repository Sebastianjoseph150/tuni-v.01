part of 'cart_bloc.dart';

@immutable
abstract class CartEvent {}

class FetchCartDataEvent extends CartEvent {}

class OnDeleteCartItem extends CartEvent {
  final String id;

  OnDeleteCartItem({required this.id});
}

class AddCartItemCountEvent extends CartEvent {
  final String itemId;

  AddCartItemCountEvent({
    required this.itemId,
  });
}

class RemoveCartItemCountEvent extends CartEvent {
  final String itemId;

  RemoveCartItemCountEvent({
    required this.itemId,
  });
}

// class GetTotalProductPrice extends CartEvent {
//   final List<Map<String,dynamic>> idList;
//   GetTotalProductPrice({required this.idList});
// }

class RazorPayEventListenersEvent extends CartEvent {}

class RazorPayEvent extends CartEvent {
  final BuildContext context;
  final String name;
  final int amount;
  final String email;
  final String mobile;
  final List<OrderModel> orderList;
  final Map<dynamic, dynamic> address;

  RazorPayEvent({
    required this.context,
    required this.amount,
    required this.orderList,
    required this.address,
    required this.name,
    required this.email,
    required this.mobile
  });
}

class CancelOrderedProductEvent extends CartEvent {
  final String orderId;
  CancelOrderedProductEvent({required this.orderId});
}
