import 'package:flutter/material.dart';
import '../../../../models/appointment_model.dart';

class AppointmentDetails extends StatelessWidget {
  final AppointmentModel appointment;

  AppointmentDetails({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'Save as PDF') {
                // Implement save as PDF functionality here
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Save as PDF',
                child: Text('Save as PDF'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //_buildDetailItem(context, 'Appointment ID', appointment.appointmentId),
              _buildDetailItem(context, 'Appointment Date', appointment.appointmentDate),
              //_buildDetailItem(context, 'Patient ID', appointment.patientId),
              _buildDetailItem(context, 'Patient Name', appointment.patientName),
              _buildDetailItem(context, 'Blood Pressure', appointment.bp),
              _buildDetailItem(context, 'Temperature', appointment.temp),
              _buildDetailItem(context, 'Heart Rate', appointment.heartRate),
              _buildDetailItem(context, 'SpO2', appointment.spO2),
              _buildDetailItem(context, 'Assigned To', appointment.assignedTo),
              _buildDetailItem(context, 'Doctor Email', appointment.doctorMail),
              //_buildDetailItem(context, 'Care Email', appointment.careMail),
              _buildDetailItem(context, 'Ward Number', appointment.wardNumber),
              _buildDetailItem(context, 'Status', appointment.status),
              _buildDetailItem(context, 'Symptoms', appointment.symptoms),
              _buildDetailItem(context, 'Prescriptions', appointment.prescriptions),
              _buildDetailItem(context, 'Tests', appointment.tests),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: Container(
                  width: constraints.maxWidth * 0.99,  // 90% of the screen width
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                  ),
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
