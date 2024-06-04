import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CareGiversService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in method
  Future<bool> checkIfUserExists(String email) async {
      List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(email);
      return signInMethods.isNotEmpty;
  }

  // Sign in or create a user
  Future<User?> signIn(String email, String password) async {
    try {
      bool userExists = await checkIfUserExists(email);

      if (userExists) {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return userCredential.user;
      } else {
        // User does not exist, create user
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
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

  Future<void> addCareGiver(String name, String email, String wardNumber, String password) async {
    User? currentUser = _auth.currentUser;

    try {
      // Check if a caregiver with the same email already exists
      final querySnapshot = await _firestore.collection('caregivers').where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        throw Exception('A caregiver with this email already exists');
      }
      await _firestore.collection('caregivers').add({
        'name': name,
        'email': email,
        'wardNumber': wardNumber,
        'password': password,
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
