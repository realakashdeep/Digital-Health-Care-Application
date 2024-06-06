import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/models/appointment_model.dart';
import 'package:final_year_project/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../services/user_services.dart';

class CareGiversForm extends StatefulWidget {
  @override
  _CareGiversFormState createState() => _CareGiversFormState();
}

class _CareGiversFormState extends State<CareGiversForm> {
  final _formKey = GlobalKey<FormState>();
  final _aadhaarController = TextEditingController();
  final _symptomsController = TextEditingController();
  final _bpController = TextEditingController();
  final _spo2Controller = TextEditingController();
  final _tempController = TextEditingController();
  final _heartRateController = TextEditingController();
  late String _assignedTo;
  late String _bloodGroup;
  final int minHeartRate = 30; // Example: Minimum heart rate
  final int maxHeartRate = 220; // Example: Maximum heart rate

  final List<String> _assignedToList = [
    'Dr Sushant',
    'Dr Akash',
    'Dr Swarup',
  ];
  final List<String> _bloodGroupList = [
    'A+',
    'B+',
    'AB+',
    'AB-',
    'A-',
    'B-',
    'O+',
    'O-'
  ];

  @override
  void initState() {
    super.initState();
    _assignedTo = _assignedToList.first;
    _bloodGroup = _bloodGroupList.first;
  }

  @override
  Widget build(BuildContext context) {
    final UserService _userService = UserService();
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Medical Input Form',
            style: TextStyle(color: Colors.white, fontSize: 24)
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white, // Change this color to whatever you need
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _buildSectionTitle('Patient Details'),
              SizedBox(height: 8),
              _buildTextField(
                controller: _aadhaarController,
                labelText: 'Aadhaar Number',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(12),
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Aadhaar number';
                  }
                  if (!RegExp(r'^\d{12}$').hasMatch(value)) {
                    return 'Please enter a valid Aadhaar number (12 digits)';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildSectionTitle('Medical Details'),
              SizedBox(height: 8),
              _buildTextField(
                controller: _symptomsController,
                labelText: 'Symptoms',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter symptoms';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _bpController,
                labelText: 'Blood Pressure (BP)',
                hintText: 'e.g. 120/80',
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                  LengthLimitingTextInputFormatter(7),
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter BP';
                  }
                  if (!RegExp(r'^\d{1,3}/\d{1,3}$').hasMatch(value)) {
                    return 'Please enter a valid BP (e.g. 120/80)';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _spo2Controller,
                labelText: 'SpO2 in %',
                hintText: 'e.g. 95',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter SpO2';
                  }
                  if (!RegExp(r'^\d{2,3}$').hasMatch(value)) {
                    return 'Please enter a valid SpO2 (e.g. 95)';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _tempController,
                labelText: 'Temperature',
                hintText: 'e.g. 98.6',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d{1,3}(\.\d{0,1})?$')),
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter temperature';
                  }
                  if (!RegExp(r'^\d{1,3}(\.\d)?$').hasMatch(value)) {
                    return 'Please enter a valid temperature (e.g. 98.6)';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _heartRateController,
                labelText: 'Heart Rate',
                hintText: 'e.g. 75',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter heart rate';
                  }
                  if (!RegExp(r'^\d{2,3}$').hasMatch(value)) {
                    return 'Please enter a valid heart rate (e.g. 75)';
                  }
                  int heartRate = int.tryParse(value)!;
                  if (heartRate < minHeartRate || heartRate > maxHeartRate) {
                    return 'Heart rate must be between $minHeartRate and $maxHeartRate';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildDropdown(
                labelText: 'Assigned To',
                value: _assignedTo,
                items: _assignedToList,
                onChanged: (newValue) {
                  setState(() {
                    _assignedTo = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a Doctor';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildDropdown(
                labelText: 'Blood Group',
                value: _bloodGroup,
                items: _bloodGroupList,
                onChanged: (newValue) {
                  setState(() {
                    _bloodGroup = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a Blood Group';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Processing Data')),
                      );

                      MyUser? user = await _userService.getUserByAadhaar(_aadhaarController.text.toString());

                      if (user != null) {
                        DateTime now = DateTime.now();
                        String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

                        AppointmentModel appointment = AppointmentModel(
                            appointmentId: '',
                            appointmentDate: formattedDate,
                            patientId: user.userId,
                            patientName: user.name,
                            bp: _bpController.text.toString(),
                            temp: _tempController.text.toString(),
                            heartRate: _heartRateController.text.toString(),
                            spO2: _spo2Controller.text.toString(),
                            assignedTo: _assignedTo,
                            status: 'assigned to $_assignedTo',
                            prescriptions: '',
                            tests: '',
                            symptoms: ''
                        );

                        try {
                          final CollectionReference appointments = FirebaseFirestore.instance.collection('appointments');

                          // Generate a unique ID for the document
                          final String documentId = appointments.doc().id;

                          appointment.appointmentId = documentId; // Set the appointment ID in the model
                          await appointments.doc(documentId).set(appointment.toJson());

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Data saved successfully')),
                          );
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to save data: $e')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('No user found with this Aadhaar number, try with new Aadhar number')),
                        );
                      }
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
                  child: Text('Submit', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String labelText,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    FormFieldValidator<String>? validator,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      value: value,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  @override
  void dispose() {
    _aadhaarController.dispose();
    _symptomsController.dispose();
    _bpController.dispose();
    _spo2Controller.dispose();
    _tempController.dispose();
    _heartRateController.dispose();
    super.dispose();
  }
}
