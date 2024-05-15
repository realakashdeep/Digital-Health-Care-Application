import 'package:final_year_project/screens/user/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/user/user_otp.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  void signInWithPhone(
      BuildContext context, String phoneNumber, MyUser user) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException exception) {},
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Otp(verificationid: verificationId, myuser: user),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
        },
        phoneNumber: "+91" + phoneNumber,
      );
    } catch (e) {
      print('Error verifying phone number: $e');
    }
  }
}
