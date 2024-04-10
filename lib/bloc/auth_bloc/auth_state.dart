part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState{}

class AuthenticationError extends AuthState {}

class LoadingState extends AuthState {}

class TextFieldsEmptyState extends AuthState {}

//Sign In States
class SignUpSuccessState extends AuthState {}

class SignUpErrorState extends AuthState {}

//
// class SignInErrorState extends AuthState {}
//
// class NoUserFoundState extends AuthState {}
//
// class WrongPasswordState extends AuthState {}


//Sign Up States
// class SignInSuccessState extends AuthState {}
//

//Google Auth
//
class GoogleSignInSuccessState extends AuthState {}
//
class GoogleSignInErrorState extends AuthState {}






