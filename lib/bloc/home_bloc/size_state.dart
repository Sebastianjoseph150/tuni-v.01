part of 'size_bloc.dart';

abstract class SizeState {}

class SizeInitial extends SizeState {}

class SizeSelectedState extends SizeState {
  final int selectedIndex;
  final String selectedSize;

  SizeSelectedState(this.selectedIndex, this.selectedSize);
}
