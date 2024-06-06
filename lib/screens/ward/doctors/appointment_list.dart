import 'package:final_year_project/models/appointment_model.dart';
import 'package:final_year_project/screens/ward/doctors/DoctorsForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentList extends StatefulWidget {
  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _appointmentsStream;

  @override
  void initState() {
    super.initState();
    fetchAppointments(); // Call fetchAppointments to initialize _appointmentsStream
  }

  Future<void> fetchAppointments() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      _appointmentsStream = FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorMail', isEqualTo: user.email)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Appointments',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _appointmentsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No appointments found.'));
          }

          final appointments = snapshot.data!.docs.map((doc) => AppointmentModel.fromSnapshot(doc)).toList();

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                elevation: 4,
                child: ListTile(
                  title: Text(
                    '${appointment.appointmentDate} \n ${appointment.patientName}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Status: ${appointment.status}'),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: appointment.status == "finished"
                      ? null
                      : () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorMedicalForm(appointment: appointment),
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
