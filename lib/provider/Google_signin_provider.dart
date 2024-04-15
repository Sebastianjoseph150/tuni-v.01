import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String?> signInWithGoogle() async {
    try {
      // Triggering the Google Sign-In flow
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      // Checking if user canceled the sign-in process
      if (googleSignInAccount == null) return null;

      // Obtaining the authentication credentials
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      // Creating the Firebase credentials from the Google credentials
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // Signing in to Firebase with the obtained credentials
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User user = authResult.user!;

      // Returning the UID if the sign-in is successful
      return user.uid;
    } catch (error) {
      // Handling any errors that occur during the sign-in process
      print("Error signing in with Google: $error");
      return null;
    }
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
