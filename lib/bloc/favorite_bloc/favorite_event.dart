part of 'favorite_bloc.dart';

@immutable
abstract class FavoriteEvent {}

class ToggleFavoriteEvent extends FavoriteEvent {
  final String productId;
  final String name;
  final dynamic imageUrl;
  final String brand;
  final String price;
  final String category;
  final String gender;
  final String time;
  final String color;
  final List size;

  ToggleFavoriteEvent({
    required this.productId,
    required this.name,
    required this.price,
    required this.brand,
    required this.imageUrl,
    required this.gender,
    required this.time,
    required this.category,
    required this.color,
    required this.size

  });
}

class CheckIsFavorite extends FavoriteEvent {
  final String productId;

  CheckIsFavorite({ required this.productId});
}


