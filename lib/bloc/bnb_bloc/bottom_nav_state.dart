part of 'bottom_nav_bloc.dart';

@immutable
abstract class BottomNavState {
  final int tabIndex;

  BottomNavState({required this.tabIndex});
}

class BottomNavInitial extends BottomNavState {
  BottomNavInitial({required super.tabIndex});
}
