import 'package:final_year_project/models/health_record_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class HealthRecordDataProvider extends ChangeNotifier {
  late FirebaseFirestore _firestore;

  HealthRecordDataProvider() {
    _firestore = FirebaseFirestore.instance;
  }

  Future<void> addPatientData(PatientHealthRecord healthRecord) async {
    try {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
      healthRecord.timeStamp = formattedDate.toString();
      await _firestore.
        collection('Records').
        doc(healthRecord.userId).
        collection("health_records").
        doc(formattedDate).
        set(healthRecord.toJson());
      notifyListeners();
    } catch (error) {
      print("Error adding patient data: $error");
      throw error;
    }
  }

  Future<List<PatientHealthRecord>> getUserHealthRecords(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Records')
          .doc(userId)
          .collection("health_records")
          .orderBy('timeStamp', descending: true)
          .get();

      List<PatientHealthRecord> healthRecords = querySnapshot.docs
          .map((doc) => PatientHealthRecord.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return healthRecords;
    } catch (error) {
      print("Error retrieving patient data: $error");
      throw error;
    }
  }

}
