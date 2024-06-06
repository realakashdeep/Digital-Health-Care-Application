import 'package:final_year_project/screens/ward/care_givers/DailyActivity.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'ViewUserDetails.dart';

class CareGiverMenuPage extends StatefulWidget {
  @override
  _CareGiverMenuPageState createState() => _CareGiverMenuPageState();
}

class _CareGiverMenuPageState extends State<CareGiverMenuPage> {
  final TextEditingController _aadhaarController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _checkAadhaarNumber(String aadhaarNumber) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('aadhaarNumber', isEqualTo: aadhaarNumber)
          .get();

      setState(() {
        _isLoading = false;
      });

      if (querySnapshot.docs.isNotEmpty) {
        print("already registered");
      } else {
        // Aadhaar number not found, show dialog
        _showAadhaarNotRegisteredDialog();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking Aadhaar number: $e')),
      );
    }
  }

  void _showAadhaarNotRegisteredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('User not registered'),
          content: Text('The Aadhaar number is not registered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add your user registration logic here
              },
              child: Text(
                'Register User',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double inputWidth = deviceWidth * 0.8;
    double buttonWidth = deviceWidth * 0.5;

    return Scaffold(
      appBar: AppBar(
        title: Text('CareGiver Menu'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 300, // Adjust the width as needed
                  child: TextFormField(
                    controller: _aadhaarController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Please Enter Aadhaar Number',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      labelText: 'Aadhaar Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Aadhaar number';
                      } else if (value.length != 12 || !RegExp(r'^\d{12}$').hasMatch(value)) {
                        return 'Please enter a valid 12-digit Aadhaar number';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: buttonWidth,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _checkAadhaarNumber(_aadhaarController.text);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewUserDetails(aadhaarNumber: _aadhaarController.text),
                          ),
                        );
                      }

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      minimumSize: Size(100, 20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Check Profile', style: TextStyle(color: Colors.white, fontSize: 15)),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: buttonWidth,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DailyActivityPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      minimumSize: Size(100, 20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('See Your Daily Activity', style: TextStyle(color: Colors.white, fontSize: 15)),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
                if (_isLoading)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
