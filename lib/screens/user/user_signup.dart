// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:final_year_project/screens/user/user_otp.dart';

class UserSignUp extends StatelessWidget {
  const UserSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/signup_user_image.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 180, left: 0, right: 0),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'Registration',
                        style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 20),
                      buildTextField("Enter Your Name"),
                      SizedBox(height: 12),
                      buildTextField("Enter Your Phone Number"),
                      SizedBox(height: 12),
                      buildTextField("Enter Your Gender"),
                      SizedBox(height: 12),
                      buildTextField("Enter Your State"),
                      SizedBox(height: 12),
                      buildTextField("Enter Your District"),
                      SizedBox(height: 12),
                      buildTextField("Enter Your Ward No"),
                      SizedBox(height: 12),
                      buildTextField("Enter Your Pin Code"),
                      SizedBox(height: 12),
                      buildTextField("Enter Your Aadhaar Number"),
                      SizedBox(height: 12),
                      buildPasswordField("Enter Your New Password"),
                      SizedBox(height: 12),
                      buildPasswordField("Confirm Your Password"),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Otp()),
                          );
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String hintText) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          labelText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          hintText: hintText,
          fillColor: Colors.white70,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        ),
      ),
    );
  }

  Widget buildPasswordField(String hintText) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          labelText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          hintText: hintText,
          fillColor: Colors.white70,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        ),
      ),
    );
  }
}
