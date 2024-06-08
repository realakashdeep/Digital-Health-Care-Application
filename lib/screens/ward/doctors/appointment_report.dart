import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../models/appointment_model.dart';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;
  List<AppointmentModel> _appointments = [];

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
          _fromDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        } else {
          _toDate = picked;
          _toDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        }
      });
    }
  }

  Future<void> _fetchAppointments(String email) async {
    if (_fromDate == null || _toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both from and to dates.')),
      );
      return;
    }

    try {
      final fromDateStr = DateFormat('yyyy-MM-dd').format(_fromDate!);
      final toDateStr = DateFormat('yyyy-MM-dd').format(_toDate!);

      final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorMail', isEqualTo: email)
          .where('appointmentDate', isGreaterThanOrEqualTo: fromDateStr)
          .where('appointmentDate', isLessThanOrEqualTo: toDateStr)
          .get();

      final appointments = snapshot.docs.map((doc) => AppointmentModel.fromSnapshot(doc)).toList();

      setState(() {
        _appointments = appointments;
      });
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
        title: Text('Appointments'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _fromDateController,
              decoration: InputDecoration(
                labelText: 'From Date',
                hintText: 'Select from date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, true),
                ),
              ),
              readOnly: true,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _toDateController,
              decoration: InputDecoration(
                labelText: 'To Date',
                hintText: 'Select to date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, false),
                ),
              ),
              readOnly: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: (){
                User? currentUser = FirebaseAuth.instance.currentUser;
                if(currentUser!= null){
                  String? email = currentUser.email;
                  if(email != null){
                    _fetchAppointments(email);
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('failed to fetch the list')),
                    );
                  }
                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('failed to fetch the list')),
                  );
                }
              },
              child: Text('Submit'),
            ),
            SizedBox(height: 16),
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
