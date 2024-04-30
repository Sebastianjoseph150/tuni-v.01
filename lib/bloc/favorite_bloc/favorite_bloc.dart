import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuni/bloc/favorite_bloc/favorite_repository.dart';

part 'favorite_event.dart';

part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteRepository favoriteRepository = FavoriteRepository();

  FavoriteBloc() : super(FavoriteInitial()) {
    on<ToggleFavoriteEvent>(toggleFavoriteEvent);
    on<CheckIsFavorite>(checkIsFavorite);
  }

  FutureOr<void> toggleFavoriteEvent(
      ToggleFavoriteEvent event, Emitter<FavoriteState> emit) async {
    try {
      final isFavorite =
          await favoriteRepository.isFavorite(productId: event.productId);
      if (isFavorite == false) {
        await favoriteRepository.addToFavorites(
            productId: event.productId,
            name: event.name,
            imageUrl: event.imageUrl,
            brand: event.brand,
            price: event.price,
            category: event.category,
            gender: event.gender,
            time: event.time,
            size: event.size);
      } else {
        await favoriteRepository.removeFromFavorites(event.productId);
      }
      emit(FavoriteChangedState(
          isFavorite: !isFavorite, productId: event.productId));
    } catch (e) {
      throw e.toString();
    }
  }

  FutureOr<void> checkIsFavorite(
      CheckIsFavorite event, Emitter<FavoriteState> emit) async {
    try {
      final isFavorite =
          await favoriteRepository.isFavorite(productId: event.productId);
      emit(FavoriteChangedState(
          isFavorite: isFavorite, productId: event.productId));
    } catch (e) {
      throw e.toString();
    }
  }
}
