part of 'personal_detail_bloc.dart';

@immutable
abstract class PersonalDetailEvent {}

class OnAddPersonalDetailsEvent extends PersonalDetailEvent {
  final String name;
  final String phone;

  OnAddPersonalDetailsEvent(
      {required this.name, required this.phone});
}
