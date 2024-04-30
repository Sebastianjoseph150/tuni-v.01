part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class OnLogoutEvent extends HomeEvent {}

class OnDeleteUserEvent extends HomeEvent {}

class OnAddCartButtonPressed extends HomeEvent {}

class OnRemoveCartButtonPressed extends HomeEvent {}

class OnAddedToCartButtonPressedEvent extends HomeEvent {
  final String id;
  final String name;
  final List image;
  final String price;
  final String color;
  final String selectedSize;
  final String itemCount;

  OnAddedToCartButtonPressedEvent({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.color,
    required this.selectedSize,
    required this.itemCount,
  });
}



