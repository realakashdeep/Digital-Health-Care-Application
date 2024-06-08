import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/models/health_record_model.dart';
import 'package:final_year_project/models/user_model.dart';
import 'package:flutter/material.dart';
import '../../../models/appointment_model.dart';
import 'PastAppointmentsPage.dart'; // Import the new page

class DoctorMedicalForm extends StatefulWidget {
  final AppointmentModel appointment;

  DoctorMedicalForm({required this.appointment});

  @override
  _DoctorMedicalFormState createState() => _DoctorMedicalFormState();
}

class _DoctorMedicalFormState extends State<DoctorMedicalForm> {
  final TextEditingController _prescriptionController = TextEditingController();
  final TextEditingController _testsController = TextEditingController();
  late PatientHealthRecord patientHealthRecord;
  late MyUser user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    patientHealthRecord = PatientHealthRecord(); // Initialize to avoid null errors
    user = MyUser.empty(); // Initialize to avoid null errors
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      // Fetch user details from Users collection using patientId as document ID
      final DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.appointment.patientId)
          .get();

      if (userDoc.exists) {
        user = MyUser.fromSnapshot(userDoc);
      } else {
        // Handle the case where the user document does not exist
        user = MyUser.empty();
      }

      // Fetch health record details from healthRecord collection using patientId as userId
      final QuerySnapshot<Map<String, dynamic>> healthRecordSnapshot = await FirebaseFirestore.instance
          .collection('healthRecord')
          .where('userId', isEqualTo: widget.appointment.patientId)
          .get();

      if (healthRecordSnapshot.docs.isNotEmpty) {
        final healthRecordDoc = healthRecordSnapshot.docs.first.data();
        patientHealthRecord = PatientHealthRecord.fromJson(healthRecordDoc);
      } else {
        patientHealthRecord = PatientHealthRecord(); // Initialize to avoid null errors
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching user details or health record: $e');
    }
  }

  @override
  void dispose() {
    _prescriptionController.dispose();
    _testsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Doctor Form', style: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Doctor Form', style: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue,
          actions: [
            PopupMenuButton<String>(
              onSelected: (String result) {
                if (result == 'See previous record') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PastAppointmentsPage(patientId: widget.appointment.patientId),
                    ),
                  );
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'See previous record',
                  child: Text('See previous record'),
                ),
              ],
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Basic Details'),
              Tab(text: 'Appointment Details'),

            ],
            indicatorColor: Colors.black45,
            labelColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            // Basic Details Tab
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildDetailCard('Full Name', user.name),
                    _buildDetailCard('Gender', user.gender),
                    _buildDetailCard('DOB', user.dob),
                    _buildDetailCard('Phone Number', user.phoneNumber),
                    _buildDetailCard('Allergies', patientHealthRecord.allergies ?? 'N/A'),
                    _buildDetailCard('Height', patientHealthRecord.height ?? 'N/A'),
                    _buildDetailCard('Weight', patientHealthRecord.weight ?? 'N/A'),
                    _buildDetailCard('Emergency Contact Name', patientHealthRecord.emergencyContactName ?? 'N/A'),
                    _buildDetailCard('Relationship', patientHealthRecord.relationship ?? 'N/A'),
                    _buildDetailCard('Emergency Contact Number', patientHealthRecord.emergencyContactPhone ?? 'N/A'),
                    _buildDetailCard('Family Medical History', patientHealthRecord.familyHistory ?? 'N/A'),
                    _buildDetailCard('Surgical History', patientHealthRecord.surgicalHistory ?? 'N/A'),
                    _buildDetailCard('Past Medical Condition', patientHealthRecord.medicalConditions ?? 'N/A'),
                  ],
                ),
              ),
            ),
            // Appointment Details Tab
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildDetailCard('Patient Name', widget.appointment.patientName),
                    _buildDetailCard('Assigned To', widget.appointment.assignedTo),
                    _buildDetailCard('BP', widget.appointment.bp),
                    _buildDetailCard('Temperature', widget.appointment.temp),
                    _buildDetailCard('Heart Rate', widget.appointment.heartRate),
                    _buildDetailCard('SpO2', widget.appointment.spO2),
                    _buildDetailCard('Status', widget.appointment.status),
                    _buildDetailCard('Symptoms', widget.appointment.symptoms),
                    SizedBox(height: 16.0),
                    Form(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _prescriptionController,
                            decoration: InputDecoration(
                              labelText: "Prescriptions",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: _testsController,
                            decoration: InputDecoration(
                              labelText: "Tests",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () async {
                              if (_prescriptionController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Please give Prescription')),
                                );
                                return; // Return early if the prescriptions field is empty
                              }
                              widget.appointment.prescriptions = _prescriptionController.text;
                              widget.appointment.tests = _testsController.text;
                              widget.appointment.status = 'Finished';
                              try {
                                final CollectionReference appointments = FirebaseFirestore.instance.collection('appointments');
                                await appointments.doc(widget.appointment.appointmentId).update(widget.appointment.toJson());
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Data saved successfully')),
                                );
                                Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to save data: $e')),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text('Save', style: TextStyle(fontSize: 18)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, String value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}
