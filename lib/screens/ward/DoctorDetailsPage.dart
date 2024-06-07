import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DoctorDetailsPage extends StatefulWidget {
  final String name;
  final String email;

  const DoctorDetailsPage({required this.name, required this.email});

  @override
  _DoctorDetailsPageState createState() => _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends State<DoctorDetailsPage> {
  DateTime? _selectedDate;
  late Future<List<Map<String, dynamic>>> _appointmentsFuture;

  @override
  void initState() {
    super.initState();
    _appointmentsFuture = _fetchAppointments();
  }

  Future<List<Map<String, dynamic>>> _fetchAppointments() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('doctorMail', isEqualTo: widget.email)
        .get();

    List<Map<String, dynamic>> appointments = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    if (_selectedDate != null) {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formattedDate = formatter.format(_selectedDate!);

      appointments = appointments
          .where((appointment) => appointment['appointmentDate'].startsWith(formattedDate))
          .toList();
    }

    return appointments;
  }

  void _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _appointmentsFuture = _fetchAppointments();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name, style: TextStyle(fontSize: 30)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Doctor Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.99,
                  child: FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance.collection('doctors').where('email', isEqualTo: widget.email).limit(1).get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Text('No data found');
                      }
                      final doctorData = snapshot.data!.docs.first.data() as Map<String, dynamic>;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailBox(label: 'Name', value: doctorData['name']),
                          _buildDetailBox(label: 'Email', value: doctorData['email']),
                          _buildDetailBox(label: 'Ward Number', value: doctorData['wardNumber']),
                        ],
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Viewed Patients',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => _pickDate(context),
                    child: Text('Select Date'),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.99,
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _appointmentsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('No appointments found');
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final appointmentData = snapshot.data![index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: ExpansionTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(appointmentData['patientName'], style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(appointmentData['assignedTo']),
                                ],
                              ),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildDetailBox(label: 'Appointment ID', value: appointmentData['appointmentId']),
                                      _buildDetailBox(label: 'Appointment Date', value: appointmentData['appointmentDate']),
                                      _buildDetailBox(label: 'Patient ID', value: appointmentData['patientId']),
                                      _buildDetailBox(label: 'Blood Pressure', value: appointmentData['bp']),
                                      _buildDetailBox(label: 'Temperature', value: appointmentData['temp']),
                                      _buildDetailBox(label: 'Heart Rate', value: appointmentData['heartRate']),
                                      _buildDetailBox(label: 'SpO2', value: appointmentData['spO2']),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailBox({required String label, required String value}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
