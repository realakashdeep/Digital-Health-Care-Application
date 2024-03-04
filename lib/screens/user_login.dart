// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

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
                        fit: BoxFit.cover
                    )
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                child:Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400
                    ),
                  ),
              ),
              const SizedBox(height: 10),
              userCred(context),
              const SizedBox(height: 10),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(150,40)
                  ),
                  onPressed: (){},
                  child:  Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
              )
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
                child:  TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "Enter User Id/Phone Number",
                    fillColor: Colors.white70,
                ),
              ),
            ),
          const SizedBox(height: 10),
          SizedBox(
              child:  TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "Enter Password",
                  fillColor: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
