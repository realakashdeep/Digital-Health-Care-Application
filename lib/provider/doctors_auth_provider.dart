import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorsAuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> checkIfUserExists(String email) async {
    List<String> signInMethods = await _firebaseAuth.fetchSignInMethodsForEmail(email);
    return signInMethods.isNotEmpty;
  }

  Future<User?> signIn(String email, String password) async {
    try {
      bool userExists = await checkIfUserExists(email);

      if (userExists) {
        UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return userCredential.user;
      } else {
        // User does not exist, create user
        UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        return userCredential.user;
      }
    } catch (e) {
      // Handle errors
      print('Error during sign-in or sign-up: $e');
      throw e;
    }
  }


  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    notifyListeners();
  }
}
