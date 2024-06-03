import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CareGiversAuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;

  User? get user => _user;

  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;

      // Check if the user exists in Firestore
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('caregivers').doc(_user!.uid).get();
      if (snapshot.exists) {
        // If user exists and email is null, update the email in Firestore
        if (snapshot.data()!['email'] == null) {
          await _firestore.collection('caregivers').doc(_user!.uid).update({'email': email});
        }
      }

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
