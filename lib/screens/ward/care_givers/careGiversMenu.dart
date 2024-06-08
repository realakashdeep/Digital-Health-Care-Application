import 'package:final_year_project/screens/ward/care_givers/DailyActivity.dart';
import 'package:final_year_project/screens/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ViewUserDetails.dart';
import 'package:flutter/services.dart';
class CareGiverMenuPage extends StatefulWidget {
  @override
  _CareGiverMenuPageState createState() => _CareGiverMenuPageState();
}

class _CareGiverMenuPageState extends State<CareGiverMenuPage> {
  final TextEditingController _aadhaarController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<bool> _checkAadhaarNumber(String aadhaarNumber) async {
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
        return true;
      } else {
        _showAadhaarNotRegisteredDialog();
        return false;
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking Aadhaar number: $e')),
      );
      return false;
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
    double inputWidth = deviceWidth * 0.9;
    double buttonWidth = deviceWidth * 0.5;

    return Scaffold(
      appBar: AppBar(
        title: Text('Care Givers Menu'),
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
                  width: inputWidth, // Adjust the width as needed
                  child: TextFormField(
                    controller: _aadhaarController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Please Enter Aadhaar Number',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      labelText: 'Enter Patient\'s Aadhaar Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear), // Icon for clear button
                        onPressed: () {
                          _aadhaarController.clear(); // Clear the text field
                        },
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
                )
                ,
                SizedBox(height: 20),
                SizedBox(
                  width: buttonWidth,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                       if(await _checkAadhaarNumber(_aadhaarController.text)){
                         Navigator.push(
                           context,
                           MaterialPageRoute(
                             builder: (context) => ViewUserDetails(aadhaarNumber: _aadhaarController.text),
                           ),
                         );
                       }

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
                SizedBox(height:10),
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
                Spacer(),

                SizedBox(
                  width: buttonWidth,
                  child: ElevatedButton(
                    onPressed: () async {
                      _showLogoutConfirmationDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      minimumSize: Size(100, 20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Log Out', style: TextStyle(color: Colors.white, fontSize: 15)),
                        SizedBox(width: 0),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
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

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Are you sure you want to log out?', style: TextStyle(fontSize: 20, color: Colors.black)),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Colors.blue,
              ),
              child: Text('No', style: TextStyle(fontSize: 14, color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () async {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomePage()),
                      (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Colors.redAccent,
              ),
              child: Text('Yes', style: TextStyle(fontSize: 14, color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
