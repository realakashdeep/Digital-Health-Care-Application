import 'dart:developer';
import 'package:final_year_project/constants/text_strings.dart';
import 'package:final_year_project/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/user_services.dart';

class Otp extends StatefulWidget {
  final String verificationid;
  final MyUser? myuser;

  Otp({super.key, required this.verificationid, this.myuser});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  bool _isLoading = false; // Add a loading state variable

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (index) => TextEditingController());
    _focusNodes = List.generate(6, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tOtp,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20), // Reduced spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                6,
                    (index) => NumericTextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  nextFocusNode: index < 5 ? _focusNodes[index + 1] : FocusNode(),
                ),
              ),
            ),
            SizedBox(height: 20), // Reduced spacing
            _isLoading // Show CircularProgressIndicator when loading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () async {
                String otp = _controllers.map((controller) => controller.text).join('');
                if (otp.length != 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Enter 6 digit OTP'),
                    ),
                  );
                } else {
                  setState(() {
                    _isLoading = true; // Set loading state to true
                  });
                  try {
                    PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationid,
                      smsCode: otp,
                    );
                    _auth.signInWithCredential(credential).then(
                          (UserCredential userCredential) async {
                        if (widget.myuser != null) {
                          widget.myuser!.userId = userCredential.user!.uid;
                          await _userService.createUser(widget.myuser!);
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/user_home',
                                (route) => false,
                          );
                        } else {
                          // Navigate to another screen if MyUser is not provided
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/user_home',
                                (route) => false,
                          );
                        }
                      },
                    ).catchError((ex) {
                      log(ex.toString());
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error verifying OTP: $ex')),
                      );
                    }).whenComplete(() {
                      setState(() {
                        _isLoading = false; // Reset loading state after the process
                      });
                    });
                  } catch (ex) {
                    log(ex.toString());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error verifying OTP: $ex')),
                    );
                    setState(() {
                      _isLoading = false; // Reset loading state after the process
                    });
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                minimumSize: Size(300, 40),
              ),
              child: Text(
                'Verify OTP',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NumericTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  const NumericTextField({
    required this.controller,
    required this.focusNode,
    required this.nextFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center, // Center font size inside box
        onChanged: (value) {
          if (value.isNotEmpty) {
            nextFocusNode.requestFocus();
          }
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          counterText: '', // Hide character counter
        ),
      ),
    );
  }
}
