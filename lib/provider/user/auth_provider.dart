import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer' as devLog;
import 'package:crypto/crypto.dart';
import '../../models/user_model.dart';
import '../../screens/user/login&signup/user_otp.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Getter for authStateChanges stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();



  Future<bool> checkIfNumberRegistered(String phoneNumber) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .where("phoneNumber", isEqualTo: phoneNumber)
          .limit(1)
          .get();
      devLog.log(querySnapshot.docs.toString(), name: "MyLog");
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking if number is registered: $e');
      return false;
    }
  }

  Future<void> registerUser(BuildContext context, MyUser user) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: "+91${user.phoneNumber}",
        verificationCompleted: (PhoneAuthCredential credential) async {
        },
        verificationFailed: (FirebaseAuthException exception) {
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Otp(verificationid: verificationId, myuser: user),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('Code auto-retrieval timeout');
        },
      );
    } catch (e) {
      print('Error registering user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error registering user: $e')),
      );
    }
  }

  Future<void> logInWithPhone(BuildContext context, String phoneNumber, String password) async {
    try {
      final QuerySnapshot result = await _firestore
          .collection('Users')
          .where('phoneNumber', isEqualTo: phoneNumber.trim())
          .get();
      final List<DocumentSnapshot> documents = result.docs;

      if (documents.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user found with this phone number.'+phoneNumber)),
        );
        return;
      }

      final userDoc = documents.first;
      final userData = userDoc.data() as Map<String, dynamic>;
      final storedHashedPassword = userData['password'];
      final enteredHashedPassword = hashPassword(password);

      if (storedHashedPassword == enteredHashedPassword) {
        // Send OTP
        await _auth.verifyPhoneNumber(
          phoneNumber: "+91$phoneNumber",
          verificationCompleted: (PhoneAuthCredential credential) async {
          },
          verificationFailed: (FirebaseAuthException exception) {
          },
          codeSent: (String verificationId, int? resendToken) {
            MyUser user = MyUser(
              userId: userDoc.id,
              name: userData['name'] ?? '',
              phoneNumber: userData['phoneNumber'] ?? '',
              gender: userData['gender'] ?? '',
              district: userData['district'] ?? '',
              state: userData['state'] ?? '',
              aadhaarNumber: userData['aadhaarNumber'] ?? '',
              password: userData['password'] ?? '',
              dob: userData['dob'] ?? '',
              ward: userData['ward'] ?? '',
              profilePictureURL: userData['profilePictureURL'] ?? '',
              dateRegistered: userData['dateRegistered'] ?? '',
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Otp(verificationid: verificationId, myuser: user),
              ),
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            print('Code auto-retrieval timeout');
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wrong password. Please try again.')),
        );
      }
    } catch (e) {
      print('Error verifying phone number: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying phone number: $e')),
      );
    }
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}
