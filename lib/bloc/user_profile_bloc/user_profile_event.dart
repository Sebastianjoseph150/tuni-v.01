part of 'user_profile_bloc.dart';

@immutable
abstract class UserProfileEvent {}

// class ResetUserProfileEvent extends UserProfileEvent {}

class OnAddUserDetailsEvent extends UserProfileEvent {
  final String firstName;
  final String lastName;
  final String number;
  // final String gender;
  // final int day;
  // final int month;
  // final int year;

  OnAddUserDetailsEvent({
    required this.firstName,
    required this.number,
    required this.lastName,
    // required this.gender,
    // required this.day,
    // required this.month,
    // required this.year,
  });
}

class OnCalenderIconClickedEvent extends UserProfileEvent {
  final BuildContext context;

  OnCalenderIconClickedEvent({required this.context});
}

class OnSelectGenderEvent extends UserProfileEvent {
  final gender;

  OnSelectGenderEvent({required this.gender});
}
