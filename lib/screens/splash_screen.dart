import 'dart:async';
import 'package:final_year_project/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_year_project/screens/user/user_home.dart';
import 'package:final_year_project/screens/welcome.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Delay navigation to show splash screen for 2 seconds
    Timer(
      Duration(seconds: 3), () => checkAuthenticationAndNavigate(context),
    );

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/local_hospital_outlined.svg', // Replace with your actual file name
              width: 100,
              height: 100,
              color: Colors.white, // You can set the desired color
            ),
            SizedBox(height: 16),
            Text(
              tTitle,
              style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void checkAuthenticationAndNavigate(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    if (user != null) {
      // User is authenticated, navigate to UserHome
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserHome()),
      );
    } else {
      // User is not authenticated, navigate to WelcomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
    }
  }
}
