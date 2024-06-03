import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import '../models/doctors_model.dart';

class DoctorsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new doctor document to Firestore
  Future<void> addDoctor(Doctor doctor) async {
    try {
      await _firestore.collection('doctors').doc(doctor.email).set(doctor.toMap());
    } catch (e) {
      throw e;
    }
  }

  // Retrieve doctor data from Firestore based on email
  Future<Doctor?> getDoctor(String email) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('doctors').doc(email).get();
      if (snapshot.exists) {
        return Doctor.fromMap(snapshot.data()!);
      }
      return null;
    } catch (e) {
      throw e;
    }
  }

  // Update doctor data in Firestore
  Future<void> updateDoctor(String email, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('doctors').doc(email).update(updatedData);
    } catch (e) {
      throw e;
    }
  }

  // Delete doctor data from Firestore
  Future<void> deleteDoctor(String email) async {
    try {
      await _firestore.collection('doctors').doc(email).delete();
    } catch (e) {
      throw e;
    }
  }
}
