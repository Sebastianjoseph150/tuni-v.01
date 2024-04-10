import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:tuni/bloc/auth_bloc/auth_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepository authRepository = AuthRepository();

  // final AuthRepository repository = AuthRepository();

  User? user = FirebaseAuth.instance.currentUser;

  AuthBloc() : super(AuthInitial()) {
    on<SignUpRequestEvent>(signUpRequestEvent);
    on<SignInRequestEvent>(signInRequestEvent);
    on<GoogleIconClickedEvent>(googleIconClickedEvent);
  }

  FutureOr<void> signUpRequestEvent(SignUpRequestEvent event,
      Emitter<AuthState> emit) async {
    try {
      // final userId = user!.uid;
      // final userEmail = user!.email;
      if (event.email.isEmpty ||
          event.password.isEmpty ||
          event.confirmPassword.isEmpty) {
        throw Exception('Mandatory fields cannot be empty');
      } else if (event.password != event.confirmPassword) {
        throw Exception("Passwords doesn't match");
      } else if (event.email.isNotEmpty &&
          event.password.isNotEmpty &&
          event.confirmPassword.isNotEmpty &&
          event.password == event.confirmPassword) {
        emit(LoadingState());
        await authRepository.signUp(
            name: event.name,
            email: event.email,
            password: event.password,
            confirmPassword: event.confirmPassword);

        emit(Authenticated());
      }
    } catch (e) {
      emit(SignUpErrorState());
      throw e.toString();
    }
  }

  FutureOr<void> signInRequestEvent(SignInRequestEvent event,
      Emitter<AuthState> emit) async {
    try {
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(TextFieldsEmptyState());
      } else if (event.email.isNotEmpty && event.password.isNotEmpty) {
        emit(LoadingState());
        await authRepository.signIn(
            email: event.email, password: event.password);
        emit(Authenticated());
      }
    } catch (e) {
      throw e.toString();
    }
  }

  FutureOr<void> googleIconClickedEvent(GoogleIconClickedEvent event,
      Emitter<AuthState> emit) async {
    emit(LoadingState());
    try {
      // await authRepository.googleSignIn();
      emit(Authenticated());
    } catch (e) {
      emit(GoogleSignInErrorState());
      throw e.toString();
    }
  }
}
