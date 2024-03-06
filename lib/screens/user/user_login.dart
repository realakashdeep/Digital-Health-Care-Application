// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:final_year_project/screens/user/user_home.dart';

class UserLogin extends StatelessWidget {
  const UserLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/login_user_image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 12),
            userCred(context),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserHome()),
                  );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                minimumSize: Size(300, 40),
              ),
              child: Text('Log In', style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }

  userCred(context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          SizedBox(
            width: 300,
            height: 50,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Enter User ID/Phone Number',
                hintText: 'Enter User ID/Phone Number',
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                alignLabelWithHint: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),  // Adjust vertical and horizontal padding as needed
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 300,
            height: 50,
            child: TextField(
              obscureText: true,  // Use obscureText for password fields
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter Password',
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                alignLabelWithHint: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),  // Adjust vertical and horizontal padding as needed
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
