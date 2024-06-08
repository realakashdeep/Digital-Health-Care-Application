import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/models/appointment_model.dart';

class PastAppointmentsPage extends StatelessWidget {
  final String patientId;

  PastAppointmentsPage({required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Past Appointments', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection('appointments')
            .where('patientId', isEqualTo: patientId)
            .where('status', isEqualTo: 'Finished')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No past appointment record'));
          }

          final appointments = snapshot.data!.docs
              .map((doc) => AppointmentModel.fromSnapshot(doc))
              .toList();

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AppointmentDetailsPopup(appointment: appointment),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.99, // 99% of screen width
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date: ${appointment.appointmentDate}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                        Text('Assigned To: ${appointment.assignedTo}'),
                        SizedBox(height: 8.0),
                        Text('Symptoms: ${appointment.symptoms}'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AppointmentDetailsPopup extends StatelessWidget {
  final AppointmentModel appointment;

  AppointmentDetailsPopup({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.99,
      width: MediaQuery.of(context).size.width * 0.8,
      child: AlertDialog(
        title: Text('Appointment Details', style: TextStyle(fontSize: 18.0)),
        contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date: ${appointment.appointmentDate}', style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 12.0),
              Text('Patient Name: ${appointment.patientName}', style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 12.0),
              Text('BP: ${appointment.bp}', style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 12.0),
              Text('Temperature: ${appointment.temp}', style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 12.0),
              Text('Heart Rate: ${appointment.heartRate}', style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 12.0),
              Text('SpO2: ${appointment.spO2}', style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 12.0),
              Text('Assigned To: ${appointment.assignedTo}', style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 12.0),
              Text('Symptoms: ${appointment.symptoms}', style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 12.0),
              Text('Prescriptions: ${appointment.prescriptions}', style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 12.0),
              Text('Tests: ${appointment.tests}', style: TextStyle(fontSize: 16.0)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}



