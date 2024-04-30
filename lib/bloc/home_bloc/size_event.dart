part of 'size_bloc.dart';

abstract class SizeEvent {}

class OnChooseSizeEvent extends SizeEvent {
  final int index;
  final String selectedSize;

  OnChooseSizeEvent({required this.index, required this.selectedSize});
}
