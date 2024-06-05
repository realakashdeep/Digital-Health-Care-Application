import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/doctors_model.dart';
import '../services/doctor_services.dart';

class DoctorsAuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final DoctorsService _doctorsService = DoctorsService();
  User? _user;

  Future<User?> signIn(String email, String password) async {
    if (await _doctorsService.checkIfUserExists(email)) {
      try {
        UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
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
      print("new doc creating");
      Doctor? doctor = await _doctorsService.getDoctor(email);

      String? doctorId = await _doctorsService.getDoctorId(email);


      if (doctor != null) {
        UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        _user = userCredential.user;

        // Add new user details to Firestore
        await _firestore.collection('doctors').doc(_user!.uid).set(doctor.toMap());

        // Delete the old doctor document using its ID
        await _firestore.collection('doctors').doc(doctorId).delete();

        print("Logged in: $userCredential");
        return _user;
      } else {
        print("Doctor details not found in Firestore.");
        return null;
      }
    }
  }

  Future<bool> checkIfUserExists(String email, String password) async {
    try {
      List<String> signInMethods = await _firebaseAuth.fetchSignInMethodsForEmail(email);
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



  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _user = null;
    notifyListeners();
  }

}
