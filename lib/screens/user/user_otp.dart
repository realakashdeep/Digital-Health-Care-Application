import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_year_project/screens/user/user_home.dart';
class Otp extends StatefulWidget {
  String verificationid;
  Otp({super.key,required this.verificationid});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

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
              'OTP Verification',
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
            ElevatedButton(
              onPressed: () async{
                String otp = _controllers.map((controller) => controller.text).join('');
                if (otp.length != 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Enter 6 digit OTP'),
                    ),
                  );
                } else {try{
                  PhoneAuthCredential credential = await PhoneAuthProvider.credential(verificationId:  widget.verificationid, smsCode: otp);
                  FirebaseAuth.instance.signInWithCredential(credential).then(
                          (value) => Navigator.push(context,MaterialPageRoute(builder: (context)=>UserHome()))
                  );
                }
                catch(ex){
                  log(ex.toString());
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
                'Submit',
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

