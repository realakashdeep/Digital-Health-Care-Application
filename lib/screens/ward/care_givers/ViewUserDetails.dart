import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../../models/health_record_model.dart';

class ViewUserDetails extends StatefulWidget {
  final String aadhaarNumber;

  ViewUserDetails({required this.aadhaarNumber});

  @override
  _ViewUserDetailsState createState() => _ViewUserDetailsState();
}

class _ViewUserDetailsState extends State<ViewUserDetails> {
   late String wardNo;
  bool _isLoading = true;
  PatientHealthRecord? _userDetails;
  List<bool> _isExpanded = [false, false];
  List<String> _doctorNames = [];
  String? _selectedDoctorName;
  late String userIdGlobal;

  // Controllers for Assign to Doctor fields
  TextEditingController _bpController = TextEditingController();
  TextEditingController _tempController = TextEditingController();
  TextEditingController _heartRateController = TextEditingController();
  TextEditingController _spO2Controller = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  TextEditingController _symptomsController = TextEditingController();
  TextEditingController _testsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('aadhaarNumber', isEqualTo: widget.aadhaarNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data();
        String userId = querySnapshot.docs.first.id;
        userIdGlobal = userId;
        String fullName = userData['name'] ?? '';
        String gender = userData['gender'] ?? '';
        String phoneNumber = userData['phoneNumber'] ?? '';
        String wardNumber = userData['ward'] ?? '';
        wardNo = wardNumber;

        await _fetchDoctors(wardNumber);

        final healthRecordSnapshot = await FirebaseFirestore.instance
            .collection('healthRecord')
            .where('userId', isEqualTo: userId)
            .limit(1)
            .get();
        print(userId);
        setState(() {
          if (healthRecordSnapshot.docs.isNotEmpty) {
            _userDetails = PatientHealthRecord.fromJson(healthRecordSnapshot.docs.first.data());
            print(healthRecordSnapshot.docs.first.data());
            print('hii');
          } else {
            _userDetails = PatientHealthRecord(
              fullName: fullName,
              dob: '',
              gender: gender,
              phoneNumber: phoneNumber,
              userId: userId,
              medicalConditions: '',
              surgicalHistory: '',
              familyHistory: '',
              allergies: '',
              height: '',
              weight: '',
              emergencyContactName: '',
              relationship: '',
              emergencyContactPhone: '',
              lastUpdated: '',
            );
          }
        });
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user details: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchDoctors(String wardNumber) async {
    try {
      print('wardNumber - $wardNumber');
      final querySnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .where('wardNumber', isEqualTo: wardNumber)
          .get();

      List<String> doctorNames = querySnapshot.docs.map((doc) => doc['name'] as String).toList();
      setState(() {
        _doctorNames = doctorNames;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching doctors: $e')),
      );
    }
  }

  @override
  void dispose() {
    _bpController.dispose();
    _tempController.dispose();
    _heartRateController.dispose();
    _spO2Controller.dispose();
    _statusController.dispose();
    _symptomsController.dispose();
    _testsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View User Details'),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: Colors.blue,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildExpansionPanelList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpansionPanelList() {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded[index] = !_isExpanded[index];
          });
        },
        children: [
          _buildBasicDetailsPanel(),
          _buildAssignToDoctorPanel(),
        ],
      ),
    );
  }

  ExpansionPanel _buildBasicDetailsPanel() {
    print("Basic Details");
    print(_userDetails?.medicalConditions);
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          title: Text(
            'Basic Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
      body: _userDetails != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem('Name', _userDetails?.fullName ?? '', context, editable: false),
            _buildDobField('Date of Birth', _userDetails?.dob, context),
            _buildDetailItem('Gender', _userDetails?.gender ?? '', context, editable: false),
            _buildDetailItem('Phone Number', _userDetails?.phoneNumber ?? '', context, editable: false),
            _buildDetailItem('Medical Conditions', _userDetails?.medicalConditions ?? '', context),
            _buildDetailItem('Surgical History', _userDetails?.surgicalHistory ?? '', context),
            _buildDetailItem('Family History', _userDetails?.familyHistory ?? '', context),
            _buildDetailItem('Allergies', _userDetails?.allergies ?? '', context),
            _buildDetailItem('Height', _userDetails?.height ?? '', context),
            _buildDetailItem('Weight', _userDetails?.weight ?? '', context),
            _buildDetailItem('Emergency Contact Name', _userDetails?.emergencyContactName ?? '', context),
            _buildDetailItem('Relationship', _userDetails?.relationship ?? '', context),
            _buildDetailItem('Emergency Contact Phone', _userDetails?.emergencyContactPhone ?? '', context),
            _buildDetailItem('Last Updated', _userDetails?.lastUpdated ?? '', context, editable: false),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showConfirmationDialog(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      )
          : Container(),
      isExpanded: _isExpanded[0],
    );
  }

  ExpansionPanel _buildAssignToDoctorPanel() {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          title: Text(
            'Assign to a Doctor',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
      body: _userDetails != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Blood Pressure', _bpController, 'e.g. 120/80'),
            _buildTextField('Temperature', _tempController, 'e.g. 98.6 (in Fahrenheit)'),
            _buildTextField('Heart Rate', _heartRateController, 'e.g. 75 (in bpm)'),
            _buildTextField('SpO2', _spO2Controller, 'e.g. 95 (in %)'),
            _buildDoctorDropdown(),
            _buildStatusTextField(),
            _buildTextField('Symptoms', _symptomsController, 'Enter Symptoms'),
            //_buildTextField('Tests', _testsController,'', editable: false),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _assignToDoctor();
              },
              child: Text('Save'),
            ),
          ],
        ),
      )
          : Container(),
      isExpanded: _isExpanded[1],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hintText, {bool editable = true}) {
    double boxWidth = MediaQuery.of(context).size.width * 0.9;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
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
          Container(
            width: boxWidth,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: editable ? Colors.grey[200] : Colors.grey[300],
            ),
            child: editable
                ? TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
              ),
            )
                : Text(
              hintText,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, BuildContext context, {bool editable = true}) {
    double boxWidth = MediaQuery.of(context).size.width * 0.9;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
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
          Container(
            width: boxWidth,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: editable ? Colors.grey[200] : Colors.grey[300],
            ),
            child: editable
                ? TextFormField(
              initialValue: value,
              onChanged: (newValue) {
                setState(() {
                  switch (label) {
                    case 'Medical Conditions':
                      _userDetails?.medicalConditions = newValue;
                      break;
                    case 'Surgical History':
                      _userDetails?.surgicalHistory = newValue;
                      break;
                    case 'Family History':
                      _userDetails?.familyHistory = newValue;
                      break;
                    case 'Allergies':
                      _userDetails?.allergies = newValue;
                      break;
                    case 'Height':
                      _userDetails?.height = newValue;
                      break;
                    case 'Weight':
                      _userDetails?.weight = newValue;
                      break;
                    case 'Emergency Contact Name':
                      _userDetails?.emergencyContactName = newValue;
                      break;
                    case 'Relationship':
                      _userDetails?.relationship = newValue;
                      break;
                    case 'Emergency Contact Phone':
                      _userDetails?.emergencyContactPhone = newValue;
                      break;

                  }
                });
              },
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            )
                : Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildDobField(String label, String? dob, BuildContext context) {
    TextEditingController _dobController = TextEditingController(text: dob);
    double boxWidth = MediaQuery.of(context).size.width * 0.9;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
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
          GestureDetector(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );

              if (pickedDate != null) {
                setState(() {
                  dob = DateFormat('yyyy-MM-dd').format(pickedDate);
                  _dobController.text = dob!;
                  _userDetails?.dob = dob!;
                });
              }
            },
            child: Container(
              width: boxWidth,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              child: AbsorbPointer(
                child: TextField(
                  controller: _dobController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorDropdown() {
    double boxWidth = MediaQuery.of(context).size.width * 0.9;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Assign to Doctor',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: boxWidth,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200],
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedDoctorName,
              hint: Text('Select a doctor'),
              items: _doctorNames.map((String name) {
                return DropdownMenuItem<String>(
                  value: name,
                  child: Text(name),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDoctorName = newValue;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTextField() {
    String status = _selectedDoctorName != null
        ? 'Assigned to $_selectedDoctorName'
        : 'Select a doctor';

    return _buildTextField('Status', _statusController, status);
  }

   Future<void> _assignToDoctor() async {
     if (_selectedDoctorName == null) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Please select a doctor')),
       );
       return;
     }

     try {
       final querySnapshot = await FirebaseFirestore.instance
           .collection('doctors')
           .where('wardNumber', isEqualTo: wardNo)
           .get();

       var doctorEmail;
       querySnapshot.docs.forEach((doctorDoc) {
         if (doctorDoc.data()['name'] == _selectedDoctorName) {
           doctorEmail = doctorDoc.data()['email'];
         }
       });

       User? user = FirebaseAuth.instance.currentUser;

       // Add the appointment to the "appointments" collection
       DocumentReference docRef = await FirebaseFirestore.instance.collection('appointments').add({
         'appointmentDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
         'patientId': _userDetails?.userId,
         'patientName': _userDetails?.fullName,
         'bp': _bpController.text,
         'temp': _tempController.text,
         'heartRate': _heartRateController.text,
         'spO2': _spO2Controller.text,
         'assignedTo': _selectedDoctorName,
         'doctorMail': doctorEmail,
         'careMail': user?.email,
         'wardNumber': wardNo,
         'status': 'Assigned to $_selectedDoctorName',
         'symptoms': _symptomsController.text,
         'prescriptions': '',
         'tests': '',
       });

       // Update the document to include the appointmentId
       await docRef.update({
         'appointmentId': docRef.id,
       });

       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Appointment created successfully')),
       );

       // Clear the text fields after saving
       _bpController.clear();
       _tempController.clear();
       _heartRateController.clear();
       _spO2Controller.clear();
       _statusController.clear();
       _symptomsController.clear();
       _testsController.clear();
     } catch (e) {
       print(e);
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Error creating appointment: $e')),
       );
     }
   }




   Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });

    await _fetchUserDetails();
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Save Changes'),
          content: Text('Are you sure you want to save the changes?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
                _saveChanges();
              },
            ),
          ],
        );
      },
    );
  }

   Future<void> _saveChanges() async {
     if (_userDetails == null) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('No user details available')),
       );
       return;
     }

     try {
       DocumentReference docRef = FirebaseFirestore.instance
           .collection('healthRecord')
           .doc(_userDetails!.userId);

       // Prepare the data to be saved
       Map<String, dynamic> healthRecordData = {
         'userId': userIdGlobal,
         'fullName': _userDetails!.fullName,
         'dob': _userDetails!.dob,
         'gender': _userDetails!.gender,
         'phoneNumber': _userDetails!.phoneNumber,
         'medicalConditions': _userDetails!.medicalConditions,
         'surgicalHistory': _userDetails!.surgicalHistory,
         'familyHistory': _userDetails!.familyHistory,
         'allergies': _userDetails!.allergies,
         'height': _userDetails!.height,
         'weight': _userDetails!.weight,
         'emergencyContactName': _userDetails!.emergencyContactName,
         'relationship': _userDetails!.relationship,
         'emergencyContactPhone': _userDetails!.emergencyContactPhone,
         'lastUpdated': DateFormat('yyyy-MM-dd').format(DateTime.now()),
       };

       // Check if the document exists
       DocumentSnapshot docSnapshot = await docRef.get();

       // If the document exists, update it. Otherwise, create a new one.
       if (docSnapshot.exists) {
         await docRef.update(healthRecordData);
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Changes saved successfully')),
         );
       } else {
         await docRef.set(healthRecordData);
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('New health record created successfully')),
         );
       }
     } catch (e) {
       print(e);
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Error saving changes: $e')),
       );
     }
   }

}
