part of 'personal_detail_bloc.dart';

abstract class PersonalDetailEvent {}

class OnAddPersonalDetailsEvent extends PersonalDetailEvent {
  final String name;
  final String phone;

  OnAddPersonalDetailsEvent(
      {required this.name, required this.phone});
}

class OnAddPersonalDetailsEventIOS extends PersonalDetailEvent {
  final String firstName;
  final String lastName;
  final String number;

  OnAddPersonalDetailsEventIOS(
      {required this.firstName, required this.lastName, required this.number});
}
