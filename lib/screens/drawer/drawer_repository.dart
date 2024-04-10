import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String getCurrentUserEmail() {
  String email = '';
  User? user = FirebaseAuth.instance.currentUser;
  if(user != null) {
   email = user.email!;

  } else {
  }
  return email;

}