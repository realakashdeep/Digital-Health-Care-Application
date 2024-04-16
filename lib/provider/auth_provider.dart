import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:final_year_project/otp_test/otp.dart';

import '../screens/user/user_otp.dart';

class AuthProvider extends ChangeNotifier{


  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        verificationCompleted: (PhoneAuthCredential credential) {
        },
        verificationFailed: (FirebaseAuthException exception) {
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (context) => Otp(verificationid: verificationId),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle code retrieval timeout if needed
        },
        phoneNumber: "+91" + phoneNumber,
      );
    } catch (e) {
      // Handle any errors that occur during phone number verification
      print('Error verifying phone number: $e');
    }
  }
}