import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../provider/patient_data_provider.dart';

class PatientInfoForm extends StatefulWidget {
  @override
  _PatientInfoFormState createState() => _PatientInfoFormState();
}

class _PatientInfoFormState extends State<PatientInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _patientData = {};

  @override
  Widget build(BuildContext context) {
    final patientDataProvider = Provider.of<PatientDataProvider>(context);
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
                PatientIdentificationInfo(patientData: _patientData),
                SizedBox(height: 20),
                DemographicInfo(patientData: _patientData),
                SizedBox(height: 20),
                MedicalHistory(patientData: _patientData),
                SizedBox(height: 20),
                CurrentHealthStatus(patientData: _patientData),
                SizedBox(height: 20),
                EmergencyContactInfo(patientData: _patientData),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        try {
                          await patientDataProvider.addPatientData(_patientData);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Data successfully saved!'),
                              backgroundColor: Colors.green,
                            ),
                          );

                          // Navigate back after a short delay to allow the user to see the SnackBar
                          Future.delayed(Duration(seconds: 2), () {
                            Navigator.pop(context);
                          });
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to save data: $error'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
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
  final Map<String, dynamic> patientData;

  PatientIdentificationInfo({required this.patientData});

  @override
  _PatientIdentificationInfoState createState() =>
      _PatientIdentificationInfoState();
}

class _PatientIdentificationInfoState extends State<PatientIdentificationInfo> {
  final TextEditingController _dobController = TextEditingController();

  @override
  void dispose() {
    _dobController.dispose();
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
          decoration: InputDecoration(
            labelText: 'User ID',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter User ID';
            }
            return null;
          },
          onSaved: (value) => widget.patientData['userId'] = value,
        ),
        SizedBox(height: 16.0),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Full Name',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Full Name';
            }
            return null;
          },
          onSaved: (value) => widget.patientData['fullName'] = value,
        ),
        SizedBox(height: 16.0),
        TextFormField(
          controller: _dobController,
          decoration: InputDecoration(
            labelText: 'Date of Birth',
            border: OutlineInputBorder(),
          ),
          readOnly: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Date of Birth';
            }
            return null;
          },
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              setState(() {
                _dobController.text =
                '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
                widget.patientData['dob'] = _dobController.text;
              });
            }
          },
        ),
        SizedBox(height: 16.0),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Gender',
            border: OutlineInputBorder(),
          ),
          items: [
            DropdownMenuItem(child: Text('Male'), value: 'Male'),
            DropdownMenuItem(child: Text('Female'), value: 'Female'),
            DropdownMenuItem(child: Text('Other'), value: 'Other'),
          ],
          onChanged: (String? value) {},
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select Gender';
            }
            return null;
          },
          onSaved: (value) => widget.patientData['gender'] = value,
        ),
      ],
    );
  }
}

// Other Widget classes remain the same

class DemographicInfo extends StatelessWidget {
  final Map<String, dynamic> patientData;

  DemographicInfo({required this.patientData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Demographic Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.0),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Address',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.streetAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Address';
            }
            return null;
          },
          onSaved: (value) => patientData['address'] = value,
        ),
        SizedBox(height: 16.0),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Phone Number';
            }
            return null;
          },
          onSaved: (value) => patientData['phoneNumber'] = value,
        ),
      ],
    );
  }
}

class MedicalHistory extends StatelessWidget {
  final Map<String, dynamic> patientData;

  MedicalHistory({required this.patientData});

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
          onSaved: (value) => patientData['medicalConditions'] = value,
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
          onSaved: (value) => patientData['surgicalHistory'] = value,
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
          onSaved: (value) => patientData['familyHistory'] = value,
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
          onSaved: (value) => patientData['allergies'] = value,
        ),
      ],
    );
  }
}

class CurrentHealthStatus extends StatelessWidget {
  final Map<String, dynamic> patientData;

  CurrentHealthStatus({required this.patientData});

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
              onSaved: (value) => patientData['height'] = value,
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
              onSaved: (value) => patientData['weight'] = value,
            ),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Blood Pressure',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Blood Pressure';
                }
                return null;
              },
              onSaved: (value) => patientData['bloodPressure'] = value,
            ),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Heart Rate (bpm)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Heart Rate';
                }
                return null;
              },
              onSaved: (value) => patientData['heartRate'] = value,
            ),
          ),
        ],
      ),
    );
  }
}
class EmergencyContactInfo extends StatelessWidget {
  final Map<String, dynamic> patientData;

  EmergencyContactInfo({required this.patientData});

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
              onSaved: (value) => patientData['emergencyContactName'] = value,
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
              onSaved: (value) => patientData['relationship'] = value,
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
              patientData['emergencyContactPhone'] = value,
            ),
          ),
        ],
      ),
    );
  }
}

