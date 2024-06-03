import 'package:final_year_project/constants/text_strings.dart';
import 'package:final_year_project/screens/ward/ward_login.dart';
import 'package:flutter/material.dart';
import 'package:final_year_project/screens/user/user_login.dart';
import 'package:final_year_project/screens/user/user_signup.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Digital HealthCare Facilities',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 80),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserLogin()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,  // Set button background color to blue
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),  // Set border radius
                  ),
                  minimumSize: Size(300, 40),
                ),
                child: Text('Log In', style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              SizedBox(height: 12),  // Add spacing between buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserSignUp()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,  // Set button background color to blue
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),  // Set border radius
                  ),
                  minimumSize: Size(300, 40),
                ),
                child: Text('Sign Up',style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              SizedBox(height: 12),  // Fill the available space between buttons and "Skip" text
              // GestureDetector(
              //   onTap: () {
              //     // Handle the "Skip" action
              //   },
              //   child: Text(
              //     tSkip,
              //     style: TextStyle(fontSize: 20, color: Colors.blue),
              //   ),
              // ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WardLoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,  // Set button background color to blue
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),  // Set border radius
                  ),
                  minimumSize: Size(300, 40),
                ),
                child: Text('Ward Log In',style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
