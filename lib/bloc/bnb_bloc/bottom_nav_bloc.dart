import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bottom_nav_event.dart';
part 'bottom_nav_state.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(BottomNavInitial(tabIndex: 0)) {
    on<BottomNavEvent>((event, emit) {
      if (event is TabChangeEvent) {
        emit (BottomNavInitial(tabIndex: event.tabIndex));
      }
    });
  }
}
