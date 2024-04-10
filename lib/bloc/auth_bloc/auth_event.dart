part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class SignUpRequestEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  SignUpRequestEvent(
      {required this.name,
      required this.email,
      required this.password,
      required this.confirmPassword});
}

class SignInRequestEvent extends AuthEvent {
  final String email;
  final String password;

  SignInRequestEvent({
    required this.email,
    required this.password,
  });
}

class GoogleIconClickedEvent extends AuthEvent {}
