import 'package:flutter/material.dart';
import 'package:final_year_project/screens/user/user_home.dart';


class Otp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.of(context).pop();
            },
            ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'OTP Verification',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NumericTextField(),
                  NumericTextField(),
                  NumericTextField(),
                  NumericTextField(),
                ],
              ),
              SizedBox(height: 40), // Space between squares and button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserHome()),
                  );
                },
                child: Container(
                  width: 300,
                  height: 40,
                  child: Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}

class Square extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      color: Colors.blue,
    );
  }
}
class NumericTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      child: TextField(
        keyboardType: TextInputType.number,
        maxLength: 2, // Limit the input length to 2 characters
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          counterText: '', // Hide the character counter
        ),
      ),
    );
  }
}
