import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientDataProvider extends ChangeNotifier {
  late FirebaseFirestore _firestore;

  PatientDataProvider() {
    _firestore = FirebaseFirestore.instance;
  }

  Future<void> addPatientData(Map<String, dynamic> data) async {
    try {
      await _firestore.collection('patients').doc(data['userId']).set(data);
      notifyListeners();
    } catch (error) {
      print("Error adding patient data: $error");
      throw error;
    }
  }
}
