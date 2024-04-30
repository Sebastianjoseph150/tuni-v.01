import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
part 'size_event.dart';
part 'size_state.dart';

class SizeBloc extends Bloc<SizeEvent, SizeState> {
  SizeBloc() : super(SizeInitial()) {
    on<OnChooseSizeEvent>(onChooseSizeEvent);

  }
  FutureOr<void> onChooseSizeEvent(
      OnChooseSizeEvent event, Emitter<SizeState> emit) async {
    try {
      int selectedIndex = -1;
      String selectedSize = '';
      if (state is SizeSelectedState &&
          (state as SizeSelectedState).selectedIndex == event.index) {
        emit(SizeSelectedState(selectedIndex, selectedSize));
      } else {
        selectedIndex = event.index;
        selectedSize = event.selectedSize;
        emit(SizeSelectedState(selectedIndex, selectedSize));
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
