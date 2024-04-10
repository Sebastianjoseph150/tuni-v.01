import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'personal_detail_event.dart';

part 'personal_detail_state.dart';

class PersonalDetailBloc
    extends Bloc<PersonalDetailEvent, PersonalDetailState> {
  final User user = FirebaseAuth.instance.currentUser!;

  PersonalDetailBloc() : super(PersonalDetailInitial()) {
    on<OnAddPersonalDetailsEvent>(onAddPersonalDetailsEvent);
  }

  FutureOr<void> onAddPersonalDetailsEvent(OnAddPersonalDetailsEvent event,
      Emitter<PersonalDetailState> emit) async {
    final userId = user.uid;
    final userEmail = user.email;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('personal_details')
        .doc(userEmail)
        .set({
      "name": event.name.toString(),
      "phone_number": event.phone.toString(),
    });
    emit(PersonalDetailsAddedState());
  }
}
