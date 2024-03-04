// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class UserSignUp extends StatelessWidget {
  const UserSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 200,
            child: Image.asset(
              'assets/signup_user_image.jpg', // Replace this with your image path
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 180,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding:  EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius:  BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child:  SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                          SizedBox(height: 10),
                          Text(
                            'Registration',
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                              width: 100.0,
                              height: 60,
                              child:  TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey[800]),
                                  hintText: "Enter Your Name",
                                  fillColor: Colors.white70,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                              width: 100.0,
                              height: 60,
                              child:  TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey[800]),
                                  hintText: "Enter Your Phone Number",
                                  fillColor: Colors.white70,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                              width: 100.0,
                              height: 60,
                              child:  TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey[800]),
                                  hintText: "Enter Your Gender",
                                  fillColor: Colors.white70,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                              width: 100.0,
                              height: 60,
                              child:  TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey[800]),
                                  hintText: "Enter Your State",
                                  fillColor: Colors.white70,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                              width: 100.0,
                              height: 60,
                              child:  TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey[800]),
                                  hintText: "Enter Your Ward No",
                                  fillColor: Colors.white70,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                              width: 100.0,
                              height: 60,
                              child:  TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey[800]),
                                  hintText: "Enter Your Pin Code",
                                  fillColor: Colors.white70,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                              width: 100.0,
                              height: 60,
                              child:  TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey[800]),
                                  hintText: "Enter Your Aadhar Number",
                                  fillColor: Colors.white70,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                              width: 100.0,
                              height: 60,
                              child:  TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey[800]),
                                  hintText: "Enter Your New Password",
                                  fillColor: Colors.white70,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                              width: 100.0,
                              height: 60,
                              child:  TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey[800]),
                                  hintText: "Confirm Your Password",
                                  fillColor: Colors.white70,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                      ],
                    ),
                     ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: Size(150,40)
                        ),
                        onPressed: (){},
                        child:  Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
