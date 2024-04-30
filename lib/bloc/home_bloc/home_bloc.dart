import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuni/bloc/home_bloc/home_bloc_repository.dart';

import '../auth_bloc/auth_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthRepository auth = AuthRepository();
  final HomeRepository homeRepository = HomeRepository();

  int itemCount = 1;
  bool isFavorite = false;


  HomeBloc() : super(HomeInitial()) {
    on<OnLogoutEvent>(onLogoutEvent);
    on<OnAddCartButtonPressed>(onAddCartButtonPressed);
    on<OnRemoveCartButtonPressed>(onRemoveCartButtonPressed);
    on<OnAddedToCartButtonPressedEvent>(onAddedToCartButtonPressedEvent);
    on<OnDeleteUserEvent>(onDeleteUserEvent);
  }

  FutureOr<void> onLogoutEvent(
      OnLogoutEvent event, Emitter<HomeState> emit) async {
    try {
      emit(LoadingState());
      await auth.signOut();
      emit(LoggedOutSuccessState());
    } catch (e) {
      emit(LoggedOutErrorState());
      throw e.toString();
    }
  }

  FutureOr<void> onDeleteUserEvent(
      OnDeleteUserEvent event, Emitter<HomeState> emit) async {
    try {
      emit(LoadingState());
      await auth.deleteUser();
      emit(AccountDeletedState());
    } catch (e) {
      emit(AccountDeletionErrorState());
      throw e.toString();
    }
  }

  FutureOr<void> onAddCartButtonPressed(
      OnAddCartButtonPressed event, Emitter<HomeState> emit) async {
    try {
      itemCount++;
      emit(ItemCountAddedState(itemCount));
    } catch (e) {
      throw e.toString();
    }
  }

  FutureOr<void> onRemoveCartButtonPressed(
      OnRemoveCartButtonPressed event, Emitter<HomeState> emit) async {
    try {
      if (itemCount > 1) {
        itemCount--;
      }
      emit(ItemCountRemovedState(itemCount));
    } catch (e) {
      throw e.toString();
    }
  }

  FutureOr<void> onAddedToCartButtonPressedEvent(
      OnAddedToCartButtonPressedEvent event, Emitter<HomeState> emit) async {
    try {
      if(event.selectedSize.isEmpty) {
        emit(SizeNotSelectedState());
        return;
      }
      homeRepository.addProductToCart(
        id: event.id,
        name: event.name,
        image: event.image,
        price: event.price,
        color: event.color,
        itemCount: event.itemCount,
        selectedSize: event.selectedSize
      );
      emit(AddedToCartSuccessState(size: ' ', itemCount: 1));
    } catch (e) {
      throw e.toString();
    }
  }


}
