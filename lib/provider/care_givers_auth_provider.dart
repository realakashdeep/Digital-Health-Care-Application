import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../services/CareGiversService.dart';

class CareGiversAuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CareGiversService _service = CareGiversService();
  User? _user;

  User? get user => _user;

  Future<bool> checkIfUserExists2(String email,password) async {
    try {
      print("trying dummy");
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: 'dummy_password', // Use a dummy password
      );

      return true;
    } on FirebaseAuthException catch (e) {
      print("logging in");
      try {
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


  Future<bool> checkIfUserExists(String email, String password) async {
    List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(email);
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
    if (await checkIfUserExists(email, password)) {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        _user = userCredential.user;
        notifyListeners();
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
    try {
      await _auth.signOut();
      _user = null;
      notifyListeners();
      print("User signed out");
    } catch (e) {
      print("Error during sign-out: $e");
      throw e;
    }
  }
}
