part of 'bottom_nav_bloc.dart';

abstract class BottomNavEvent {}

class TabChangeEvent extends BottomNavEvent {
  final int tabIndex;

  TabChangeEvent({required this.tabIndex});

}
