import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  FirebaseAuth auth = FirebaseAuth.instance;
  final fireStoreData = FirebaseFirestore.instance.collection('UserDetails');

  Future<UserCredential?> signUp(
      {required String name,
      required String email,
      required String password,
      required String confirmPassword}) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredential;
  }

// original ....
  // Future<void> signIn({required String email, required String password}) async {
  //   try {
  //     UserCredential userCredential = await auth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //     User user = userCredential.user!;
  //   } catch (e) {
  //     throw e.toString();
  //   }
  // }
  // test..
  Future<bool> signIn({required String email, required String password}) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = userCredential.user!;
      return true; // Sign-in successful
    } catch (e) {
      print("Error signing in: $e");
      return false; // Sign-in failed
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  // Future<OAuthCredential> googleSignIn() async {
  //   try {
  //     print('hiiiiiiii');
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     final GoogleSignInAuthentication? googleAuth =
  //         await googleUser?.authentication;
  //     final credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
  //     await auth.signInWithCredential(credential);
  //     return credential; // return the OAuthCredential
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   }
  // }
}
