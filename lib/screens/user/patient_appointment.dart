import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../models/appointment_model.dart';

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
      if(currentUser!= null){
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
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Patient Name')),
                      DataColumn(label: Text('Appointment Date')),
                      DataColumn(label: Text('BP')),
                      DataColumn(label: Text('Temperature')),
                      DataColumn(label: Text('Heart Rate')),
                      DataColumn(label: Text('SpO2')),
                      DataColumn(label: Text('Assigned To')),
                      DataColumn(label: Text('Doctor Mail')),
                      DataColumn(label: Text('Care Mail')),
                      DataColumn(label: Text('Ward Number')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Symptoms')),
                      DataColumn(label: Text('Prescriptions')),
                      DataColumn(label: Text('Tests')),
                    ],
                    rows: _appointments.map((appointment) {
                      return DataRow(cells: [
                        DataCell(Text(appointment.patientName)),
                        DataCell(Text(appointment.appointmentDate)),
                        DataCell(Text(appointment.bp)),
                        DataCell(Text(appointment.temp)),
                        DataCell(Text(appointment.heartRate)),
                        DataCell(Text(appointment.spO2)),
                        DataCell(Text(appointment.assignedTo)),
                        DataCell(Text(appointment.doctorMail)),
                        DataCell(Text(appointment.careMail)),
                        DataCell(Text(appointment.wardNumber)),
                        DataCell(Text(appointment.status)),
                        DataCell(Text(appointment.symptoms)),
                        DataCell(Text(appointment.prescriptions)),
                        DataCell(Text(appointment.tests)),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
