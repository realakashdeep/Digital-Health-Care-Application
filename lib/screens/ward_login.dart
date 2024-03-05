import 'package:final_year_project/screens/ward_menu.dart';
import 'package:flutter/material.dart';

class WardLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital HealthCare Facilities'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          //padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 22),
              Text(
                'Ward Login',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 80),  // Adjust the spacing based on your design
              Container(
                width: 300,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Ward ID',
                    hintText: 'Enter Ward ID',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: 300,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: TextField(
                  obscureText: true,  // Use obscureText for password fields
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter Ward Password',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WardMenuPage()), // Navigate to WardMenuPage
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
      ),
    );
  }
}