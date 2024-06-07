import 'dart:developer';
import 'package:final_year_project/screens/user/user_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyOtp extends StatelessWidget {
  String verificationid; 
  MyOtp({super.key,required this.verificationid}); 

  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Screen"),
        centerTitle: true,

      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: otpController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "enter the otp",
                suffix: Icon(Icons.phone),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25))
              ),
            ),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () async{
              try{
                PhoneAuthCredential credential = await PhoneAuthProvider.credential(verificationId:  verificationid, smsCode: otpController.text.toString());
                FirebaseAuth.instance.signInWithCredential(credential).then(
                  (value) => Navigator.push(context,MaterialPageRoute(builder: (context)=>UserHome()))
                );
              }
              catch(ex){
                log(ex.toString());
              }
            },
            child: Text("Otp")
          )
        ],
      ),
    );
  }
}