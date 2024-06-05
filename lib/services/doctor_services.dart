import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../models/doctors_model.dart';
import '../provider/ward_user_provider.dart';

class DoctorsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> checkIfUserExists(String email) async {
    List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(email);
    if(signInMethods.isNotEmpty)
      print("user exists");
    return signInMethods.isNotEmpty;
  }

  Future<void> addDoctor(Doctor doctor) async {

    UserCredential? userCredential;
    final querySnapshot = await _firestore.collection('doctors').where('email', isEqualTo: doctor.email).get();
    if (querySnapshot.docs.isNotEmpty) {
      throw Exception('A doctor with this email already exists');
    }
    try {
      bool userExists = await checkIfUserExists(doctor.email);
      if (!userExists) {
        await _firestore.collection('doctors').add(doctor.toMap());
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  // Retrieve doctor data from Firestore based on email
  Future<Doctor?> getDoctor(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return Doctor.fromMap(querySnapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      throw e;
    }
  }
  Future<String?> getDoctorId(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String doctorId = querySnapshot.docs.first.id;
        return doctorId;
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
