import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/caregivers_model.dart';

class CareGiversService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in method
  Future<bool> checkIfUserExists(String email) async {
      List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(email);
      if(signInMethods.isNotEmpty)
        print("user exists");
      return signInMethods.isNotEmpty;
  }




  Future<void> addCareGiver(String name, String email, String wardNumber, String password) async {
    try {
      final querySnapshot = await _firestore.collection('caregivers').where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        throw Exception('A caregiver with this email already exists');
      }

      bool emailExists = await checkIfUserExists(email);
      if (!emailExists) {
        await _firestore.collection('caregivers').add({
          'name': name,
          'email': email,
          'wardNumber': wardNumber,
          'password': password,
          'isCareGiver': true,
        });
      }
    } catch (e) {
      throw e;
    }
  }




  // Retrieve caregiver data from Firestore based on UID
  Future<CareGiver?> getCareGiver(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('caregivers')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return CareGiver.fromMap(querySnapshot.docs.first.data());
      }
      print("caregiver empty");
      return null;
    } catch (e) {
      print("Error getting caregiver: $e");
      return null; // or throw e; depending on your error handling strategy
    }
  }

  Future<String?> getCareGiverId(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('caregivers')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final caregiverId = querySnapshot.docs.first.id;
        return caregiverId;
      }
      print("caregiver empty");
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
  Future<void> deleteCareGiver(String email) async {
    String id = getCareGiverId(email) as String;
    print(id);
    try {
      await _firestore.collection('caregivers').doc(email).delete();
    } catch (e) {
      throw e;
    }
  }
}
