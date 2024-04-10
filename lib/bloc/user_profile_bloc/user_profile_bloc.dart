import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'user_profile_event.dart';

part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  User? user = FirebaseAuth.instance.currentUser;

  UserProfileBloc() : super(UserProfileInitial()) {
    on<OnAddUserDetailsEvent>(onAddUserDetailsEvent);
    on<OnCalenderIconClickedEvent>(onCalenderIconClickedEvent);
    on<OnSelectGenderEvent>(onSelectGenderEvent);
  }

  FutureOr<void> onAddUserDetailsEvent(
      OnAddUserDetailsEvent event, Emitter<UserProfileState> emit) async {
    try {
      final userId = user!.uid;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("personal_details")
          .doc(user!.email)
          .set({
        "first_name": event.firstName,
        "last_name": event.lastName,
        "phone_number": event.number,
        "email": user!.email,
        "gender": event.gender,
        "date": {
          "day": event.day,
          "month": event.month,
          "year": event.year,
        }
      });
      emit(UserDetailAddedState());
    } catch (e) {
      throw e.toString();
    }
  }

  FutureOr<void> onCalenderIconClickedEvent(
      OnCalenderIconClickedEvent event, Emitter<UserProfileState> emit) async {
    try {
      DateTime selectedDateTime = DateTime.now();
      final DateTime? dateTime = await showDatePicker(
          context: event.context,
          initialDate: selectedDateTime,
          firstDate: DateTime(1980),
          lastDate: DateTime.now());
      if (dateTime != null) {
        selectedDateTime = dateTime;
        emit(DateOfBirthSelectedState(selectedDate: selectedDateTime));
      }
    } catch (e) {
      throw e.toString();
    }
  }

  FutureOr<void> onSelectGenderEvent(
      OnSelectGenderEvent event, Emitter<UserProfileState> emit) async {
    try {
      final String gender;
      gender = event.gender;
      debugPrint(gender);
      emit(GenderSelectedState(gender: gender));
    } catch (e) {
      throw e.toString();
    }
  }

  // FutureOr<void> resetUserProfileEvent(
  //     ResetUserProfileEvent event, Emitter<UserProfileState> emit) async {
  //   emit(UserProfileInitial());
  // }
}
