import 'package:final_year_project/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/user/user_otp.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  // void signInWithPhone(BuildContext context, String phoneNumber, MyUser user) async {
  //   try {
  //     await _auth.verifyPhoneNumber(
  //       verificationCompleted: (PhoneAuthCredential credential) {},
  //       verificationFailed: (FirebaseAuthException exception) {},
  //       codeSent: (String verificationId, int? resendToken) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) =>
  //                 Otp(verificationid: verificationId, myuser: user),
  //           ),
  //         );
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {
  //       },
  //       phoneNumber: "+91" + phoneNumber,
  //     );
  //   } catch (e) {
  //     print('Error verifying phone number: $e');
  //   }
  // }

  void signInWithPhone(BuildContext context, String phoneNumber, {MyUser? user}) async {
    try {
      await _auth.verifyPhoneNumber(
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Automatically signs in the user upon verification completion
          await _auth.signInWithCredential(credential);
          // You can navigate to the next screen or perform any necessary actions here
          Navigator.pushReplacementNamed(context, '/home');
        },
        verificationFailed: (FirebaseAuthException exception) {
          // Handle verification failure (e.g., invalid phone number)
          print('Verification failed: ${exception.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          // Navigate to the OTP screen where the user enters the code
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Otp(verificationid: verificationId, myuser: user),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle code auto-retrieval timeout (if needed)
          print('Code auto-retrieval timeout');
        },
        phoneNumber: "+91$phoneNumber", // Assuming country code is included in the phone number
      );
    } catch (e) {
      print('Error verifying phone number: $e');
    }
  }

}
