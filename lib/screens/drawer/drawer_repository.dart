import 'package:firebase_auth/firebase_auth.dart';

String getCurrentUserEmail() {
  String email = '';
  User? user = FirebaseAuth.instance.currentUser;
  if(user != null) {
   email = user.email!;

  } else {
  }
  return email;

}