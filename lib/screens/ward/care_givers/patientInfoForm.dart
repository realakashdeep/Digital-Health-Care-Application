import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/models/health_record_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../models/user_model.dart';
import '../../../services/user_services.dart';

class PatientInfoForm extends StatefulWidget {
  @override
  _PatientInfoFormState createState() => _PatientInfoFormState();
}

class _PatientInfoFormState extends State<PatientInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final _aadhaarController = TextEditingController();
  final PatientHealthRecord _patientHealthRecord = PatientHealthRecord();

  @override
  Widget build(BuildContext context) {
    final UserService _userService = UserService();
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Information Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                PatientIdentificationInfo(aadharController: _aadhaarController),
                SizedBox(height: 20),
                MedicalHistory(healthRecord: _patientHealthRecord),
                SizedBox(height: 20),
                CurrentHealthStatus(healthRecord: _patientHealthRecord),
                SizedBox(height: 20),
                EmergencyContactInfo(healthRecord: _patientHealthRecord),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Data Processing'),
                                  backgroundColor: Colors.green,
                                ),
                        );

                        MyUser? user = await _userService.getUserByAadhaar(_aadhaarController.text.toString());

                        if (user != null) {
                            DateTime now = DateTime.now();
                            String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

                            _patientHealthRecord.gender = user.gender;
                            _patientHealthRecord.phoneNumber = user.phoneNumber;
                            _patientHealthRecord.fullName = user.name;
                            _patientHealthRecord.dob = user.dob;
                            _patientHealthRecord.userId = user.userId;
                            _patientHealthRecord.lastUpdated = formattedDate;

                            try {
                              final CollectionReference _healthRecords = FirebaseFirestore.instance.collection('healthRecord');

                              final String documentId = _healthRecords.doc().id;
                              await _healthRecords.doc(documentId).set(_patientHealthRecord.toJson());

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
                      }
                    ,
                    child: Text('Submit'),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PatientIdentificationInfo extends StatefulWidget {
  final TextEditingController aadharController;
  PatientIdentificationInfo({required this.aadharController});

  @override
  _PatientIdentificationInfoState createState() =>
      _PatientIdentificationInfoState();
}

class _PatientIdentificationInfoState extends State<PatientIdentificationInfo> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Patient Identification Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.0),
        TextFormField(
          controller: widget.aadharController,
          decoration: InputDecoration(
            labelText: 'Aadhaar Number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(12),
          ],
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter Aadhaar number';
            }
            if (!RegExp(r'^\d{12}$').hasMatch(value)) {
              return 'Please enter a valid Aadhaar number (12 digits)';
            }
            return null;
          }
        ),
        SizedBox(height: 16.0),
      ],
    );
  }
}
class MedicalHistory extends StatelessWidget {
  final PatientHealthRecord healthRecord;

  MedicalHistory({required this.healthRecord});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Medical History',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.0),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Past Medical Conditions',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.text,
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Past Medical Conditions';
            }
            return null;
          },
          onSaved: (value) => healthRecord.medicalConditions = value,
        ),
        SizedBox(height: 16.0),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Surgical History',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.text,
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Surgical History';
            }
            return null;
          },
          onSaved: (value) => healthRecord.surgicalHistory = value,
        ),
        SizedBox(height: 16.0),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Family Medical History',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.text,
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Family Medical History';
            }
            return null;
          },
          onSaved: (value) => healthRecord.familyHistory = value,
        ),
        SizedBox(height: 16.0),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Allergies',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.text,
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Allergies';
            }
            return null;
          },
          onSaved: (value) => healthRecord.allergies = value,
        ),
      ],
    );
  }
}

class CurrentHealthStatus extends StatelessWidget {
  final PatientHealthRecord healthRecord;

  CurrentHealthStatus({required this.healthRecord});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Current Health Status',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Height (cm)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Height';
                }
                return null;
              },
              onSaved: (value) => healthRecord.height = value,
            ),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Weight';
                }
                return null;
              },
              onSaved: (value) => healthRecord.weight = value,
            ),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}

class EmergencyContactInfo extends StatelessWidget {
  final PatientHealthRecord healthRecord;

  EmergencyContactInfo({required this.healthRecord});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Emergency Contact Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Emergency Contact Name',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Emergency Contact Name';
                }
                return null;
              },
              onSaved: (value) => healthRecord.emergencyContactName = value,
            ),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Relationship',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Relationship';
                }
                return null;
              },
              onSaved: (value) => healthRecord.relationship = value,
            ),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Emergency Contact Phone',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Emergency Contact Phone';
                }
                return null;
              },
              onSaved: (value) =>
              healthRecord.emergencyContactPhone = value,
            ),
          ),
        ],
      ),
    );
  }
}
