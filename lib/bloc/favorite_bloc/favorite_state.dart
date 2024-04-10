part of 'favorite_bloc.dart';

@immutable
abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteChangedState extends FavoriteState {
  final bool isFavorite;
  final String productId;

  FavoriteChangedState({required this.isFavorite, required this.productId});
}

class IsFavoriteInitialCheckState extends FavoriteState {
  final bool isFavorite;
  final String productId;

  IsFavoriteInitialCheckState({required this.isFavorite, required this.productId});
}