import 'package:final_year_project/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorsAuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;

  Future<bool> checkIfUserExists(String email, String password) async {
    _firebaseAuth.fetchSignInMethodsForEmail(email).then((result) => {
    print(result)
    });
    List<String> signInMethods = await _firebaseAuth.fetchSignInMethodsForEmail(email);
    if(signInMethods.isNotEmpty){
      return true; // User exists
    } else {
      try {
        // Create a new user if no sign-in methods are found
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        return true; // User created successfully
      } catch (e) {
        print("Error creating user: $e");
        return false; // User creation failed
      }
    }
  }

  Future<User?> signIn(String email, String password) async {

    if(await checkIfUserExists(email, password)){
      try {
        UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        _user = userCredential.user;
        notifyListeners(); // Notify listeners about user change
        print("logged in");
        return _user; // Return the user after successful sign-in
      } on FirebaseAuthException catch (e) {
        print("Exception during sign-in: ${e.message}");
        throw e; // Rethrow the exception
      }
    } else {
      print("returning null");
      return null;
    }
  }




  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    notifyListeners();
  }
}
