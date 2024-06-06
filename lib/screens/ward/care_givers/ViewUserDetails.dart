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
  bool _isLoading = true;
  PatientHealthRecord? _userDetails;
  List<bool> _isExpanded = [false, false];

  // Controllers for Assign to Doctor fields
  TextEditingController _bpController = TextEditingController();
  TextEditingController _tempController = TextEditingController();
  TextEditingController _heartRateController = TextEditingController();
  TextEditingController _spO2Controller = TextEditingController();
  TextEditingController _assignedToController = TextEditingController();
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
      // Fetch userId using aadhaarNumber from Users collection
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('aadhaarNumber', isEqualTo: widget.aadhaarNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print(querySnapshot.docs.first.data());
        String userId = querySnapshot.docs.first.id;
        print(userId);

        // Fetch user details from healthRecord collection using userId
        final healthRecordSnapshot = await FirebaseFirestore.instance
            .collection('healthRecord')
            .where('userId', isEqualTo: userId)
            .limit(1)
            .get();

        if (healthRecordSnapshot.docs.isNotEmpty) {
          print(healthRecordSnapshot.docs.first.data());
          setState(() {
            _userDetails =
                PatientHealthRecord.fromJson(healthRecordSnapshot.docs.first.data());
          });
          print(_userDetails?.weight);
        }
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

  @override
  void dispose() {
    _bpController.dispose();
    _tempController.dispose();
    _heartRateController.dispose();
    _spO2Controller.dispose();
    _assignedToController.dispose();
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
      body: _isLoading
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
            _buildDetailItem('Name', _userDetails!.fullName, context, editable: false),
            _buildDetailItem('Date of Birth', _userDetails!.dob, context),
            _buildDetailItem('Gender', _userDetails!.gender, context, editable: false),
            _buildDetailItem('Phone Number', _userDetails!.phoneNumber, context, editable: false),
            _buildDetailItem('Medical Conditions', _userDetails!.medicalConditions, context),
            _buildDetailItem('Surgical History', _userDetails!.surgicalHistory, context),
            _buildDetailItem('Family History', _userDetails!.familyHistory, context),
            _buildDetailItem('Allergies', _userDetails!.allergies, context),
            _buildDetailItem('Height', _userDetails!.height, context),
            _buildDetailItem('Weight', _userDetails!.weight, context),
            _buildDetailItem('Emergency Contact Name', _userDetails!.emergencyContactName, context),
            _buildDetailItem('Relationship', _userDetails!.relationship, context),
            _buildDetailItem('Emergency Contact Phone', _userDetails!.emergencyContactPhone, context),
            _buildDetailItem('Last Updated', _userDetails!.lastUpdated, context),
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
          : Container(), // Instead of Padding with empty children
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
            _buildTextField('Blood Pressure', _bpController),
            _buildTextField('Temperature', _tempController),
            _buildTextField('Heart Rate', _heartRateController),
            _buildTextField('SpO2', _spO2Controller),
            _buildTextField('Assigned To', _assignedToController),
            _buildTextField('Status', _statusController),
            _buildTextField('Symptoms', _symptomsController),
            _buildTextField('Tests', _testsController),
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
          : Container(), // Instead of Padding with empty children
      isExpanded: _isExpanded[1],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
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
              color: Colors.grey[200],
            ),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateUserDetails() async {
    setState(() {
      _isLoading = true; // Set isLoading to true to show the loading indicator
    });

    try {
      print(FirebaseFirestore.instance
          .collection('healthRecord')
          .doc(_userDetails!.userId));
      // Update user details in Firestore
      await FirebaseFirestore.instance
          .collection('healthRecord')
          .doc(_userDetails!.userId)
          .update({
        'fullName': _userDetails?.fullName,
        'dob': _userDetails?.dob,
        'phoneNumber': _userDetails?.phoneNumber,
        'gender': _userDetails?.gender,
        'userId': _userDetails?.userId,
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
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User details updated successfully')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating user details: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Set isLoading back to false to hide the loading indicator
      });
    }
  }

  Future<void> _assignToDoctor() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      await FirebaseFirestore.instance
          .collection('healthRecord')
          .doc(_userDetails!.userId)
          .update({
        'bp': _bpController.text,
        'temp': _tempController.text,
        'heartRate': _heartRateController.text,
        'spO2': _spO2Controller.text,
        'assignedTo': _assignedToController.text,
        'status': _statusController.text,
        'symptoms': _symptomsController.text,
        'tests': _testsController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Details assigned to doctor successfully')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error assigning details: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AbsorbPointer( // AbsorbPointer prevents interaction with the screen
          absorbing: _isLoading, // If isLoading is true, absorb interactions
          child: Stack(
            alignment: Alignment.center,
            children: [
              AlertDialog(
                title: Text('Are you sure to update?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      _updateUserDetails();
                      Navigator.of(context).pop();
                    },
                    child: Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('No'),
                  ),
                ],
              ),
              if (_isLoading) // Show CircularProgressIndicator while loading
                CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String? value, BuildContext context, {bool editable = true}) {
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
              color: Colors.grey[200],
            ),
            child: editable
                ? TextFormField(
              initialValue: value,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              onChanged: (newValue) {
                // Handle changes if needed
              },
            )
                : Text(
              value ?? '',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
