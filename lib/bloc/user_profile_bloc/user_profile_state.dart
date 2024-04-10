part of 'user_profile_bloc.dart';

@immutable
abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserDetailAddedState extends UserProfileState {}

class DateOfBirthSelectedState extends UserProfileState {
  final DateTime selectedDate;
  DateOfBirthSelectedState({required this.selectedDate});
}

class GenderSelectedState extends UserProfileState {
  final String gender;
  GenderSelectedState({required this.gender});
}
