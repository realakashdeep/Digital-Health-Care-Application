import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../models/appointment_model.dart';
import 'AppointmentDetails.dart';  // Import the new page

class PatientAppointmentReport extends StatefulWidget {
  @override
  _PatientAppointmentReportState createState() => _PatientAppointmentReportState();
}

class _PatientAppointmentReportState extends State<PatientAppointmentReport> {
  List<AppointmentModel> _appointments = [];

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
            .collection('appointments')
            .where('patientId', isEqualTo: currentUser.uid)
            .get();

        final appointments = snapshot.docs.map((doc) => AppointmentModel.fromSnapshot(doc)).toList();

        setState(() {
          _appointments = appointments;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch appointments: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Appointments'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _appointments.isEmpty
            ? Center(
          child: Text(
            'No reports till now',
            style: TextStyle(fontSize: 18),
          ),
        )
            : ListView.builder(
          itemCount: _appointments.length,
          itemBuilder: (context, index) {
            final appointment = _appointments[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                title: Text(
                  appointment.patientName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Appointment Date: ${appointment.appointmentDate}'),
                    Text('Assigned To: ${appointment.assignedTo}'),
                  ],
                ),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  print(appointment);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppointmentDetails(appointment: appointment),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
