import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/caregivers_model.dart';
import '../models/doctors_model.dart';
import '../services/CareGiversService.dart';
import '../services/doctor_services.dart';

class CareGiversAuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CareGiversService _service = CareGiversService();
  User? _user;
  final CareGiversService _careGiversService = CareGiversService();
  User? get user => _user;


  Future<bool> checkIfUserExists(String email, String password) async {
    try {
      List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(email);
      print(signInMethods);

      if (signInMethods.isNotEmpty) {
        print("user exists");
        return true; // User exists
      } else {
        return false;
      }
    } catch (e) {
      print("Error checking sign-in methods: $e");
      return false;
    }
  }
  Future<User?> signIn(String email, String password) async {
    if (await _careGiversService.checkIfUserExists(email)) {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        _user = userCredential.user;
        print("Logged in: $userCredential");
        return _user;
      } on FirebaseAuthException catch (e) {
        print("Exception during sign-in: ${e.message}");
        throw e;
      }
    } else {
      print("new cg creating");
      CareGiver? caregiver = await _careGiversService.getCareGiver(email);

      String? id = await _careGiversService.getCareGiverId(email);


      if (caregiver != null) {
        print("adding to firebase auth");
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        _user = userCredential.user;

        // Add new user details to Firestore
        await _firestore.collection('caregivers').doc(_user!.uid).set(caregiver.toMap());

        // Delete the old doctor document using its ID
        await _firestore.collection('caregivers').doc(id).delete();

        print("Logged in: $userCredential");
        return _user;
      } else {
        print("caregiver details not found in Firestore.");
        return null;
      }
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
