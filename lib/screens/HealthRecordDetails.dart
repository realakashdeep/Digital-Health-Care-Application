import 'package:flutter/material.dart';
import 'package:final_year_project/models/health_record_model.dart';

class UserHealthRecordDetailPage extends StatelessWidget {
  final PatientHealthRecord healthRecord;

  UserHealthRecordDetailPage({required this.healthRecord});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Health Record Detail',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem('Full Name', healthRecord.fullName ?? ''),
            // _buildDetailItem('Date of Birth', healthRecord.dob ?? ''),
            _buildDetailItem('Gender', healthRecord.gender ?? ''),
            // _buildDetailItem('Address', healthRecord.address ?? ''),
            _buildDetailItem('Phone Number', healthRecord.phoneNumber ?? ''),
            _buildDetailItem('Medical Conditions', healthRecord.medicalConditions ?? ''),
            _buildDetailItem('Surgical History', healthRecord.surgicalHistory ?? ''),
            _buildDetailItem('Family History', healthRecord.familyHistory ?? ''),
            _buildDetailItem('Allergies', healthRecord.allergies ?? ''),
            _buildDetailItem('Height', healthRecord.height ?? ''),
            _buildDetailItem('Weight', healthRecord.weight ?? ''),
            // _buildDetailItem('Blood Pressure', healthRecord.bloodPressure ?? ''),
            // _buildDetailItem('Heart Rate', healthRecord.heartRate ?? ''),
            _buildDetailItem('Emergency Contact Name', healthRecord.emergencyContactName ?? ''),
            _buildDetailItem('Relationship', healthRecord.relationship ?? ''),
            _buildDetailItem('Emergency Contact Phone', healthRecord.emergencyContactPhone ?? ''),
            // _buildDetailItem('Timestamp', healthRecord.timeStamp ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + ":",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          value,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 12.0),
      ],
    );
  }
}
