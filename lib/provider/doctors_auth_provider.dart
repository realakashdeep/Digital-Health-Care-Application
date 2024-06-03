import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Doctor {
  final String doctorId;
  final String email;

  Doctor({required this.doctorId, required this.email});
}

class DoctorsAuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Doctor? _doctor;

  Doctor? get doctor => _doctor;

  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _doctor = Doctor(
        doctorId: userCredential.user!.uid,
        email: email,
      );
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _doctor = null;
    notifyListeners();
  }
}