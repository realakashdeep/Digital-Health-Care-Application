import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CareGiversService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in method
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw e;
    }
  }

  // Add a new caregiver document to Firestore
  Future<void> addCareGiver(String uid, String name, String email, String wardNumber) async {
    try {
      await _firestore.collection('caregivers').doc(uid).set({
        'name': name,
        'email': email,
        'wardNumber': wardNumber,
      });
    } catch (e) {
      throw e;
    }
  }

  // Retrieve caregiver data from Firestore based on UID
  Future<Map<String, dynamic>?> getCareGiver(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('caregivers').doc(uid).get();
      if (snapshot.exists) {
        return snapshot.data();
      }
      return null;
    } catch (e) {
      throw e;
    }
  }

  // Update caregiver data in Firestore
  Future<void> updateCareGiver(String uid, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('caregivers').doc(uid).update(updatedData);
    } catch (e) {
      throw e;
    }
  }

  // Delete caregiver data from Firestore
  Future<void> deleteCareGiver(String uid) async {
    try {
      await _firestore.collection('caregivers').doc(uid).delete();
    } catch (e) {
      throw e;
    }
  }
}
