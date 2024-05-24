import 'dart:async';
import 'package:final_year_project/provider/auth_checker.dart';
import 'package:flutter/material.dart';
import 'package:final_year_project/screens/welcome.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/text_strings.dart'; // Import your initial screen

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Delay navigation to show splash screen for 2 seconds
    Timer(
      Duration(seconds: 3),
          () {
        final navigator = Navigator.of(context);
        if (navigator != null && navigator.canPop()) {
          navigator.pop();
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AuthChecker()),
          );
        }
      },
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
}
