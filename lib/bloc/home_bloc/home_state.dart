part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class LoadingState extends HomeState {}

class LoggedOutSuccessState extends HomeState {}

class LoggedOutErrorState extends HomeState {}

class AccountDeletedState extends HomeState {}

class AccountDeletionErrorState extends HomeState {}



class ItemCountAddedState extends HomeState {
  final int itemCount;

  ItemCountAddedState(this.itemCount);
}

class ItemCountRemovedState extends HomeState {
  final int itemCount;

  ItemCountRemovedState(this.itemCount);
}

class AddedToCartSuccessState extends HomeState {
  final String size;
  final int itemCount;
  AddedToCartSuccessState({
    required this.size,
    required this.itemCount
});
}

class SizeNotSelectedState extends HomeState {}


