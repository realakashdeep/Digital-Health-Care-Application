import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'CurrentCampsPage.dart';
import 'RegisterUserPage.dart';

class WardMenuPage extends StatelessWidget {
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
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterUserPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(300, 40),
                ),
                icon: Padding(
                  padding: const EdgeInsets.only(left: 8.0), // Adjust the left padding as needed
                  child: SvgPicture.asset(
                    'assets/add_user.svg',
                    color: Colors.white, // Set the color of the SVG
                    width: 24,
                    height: 24,
                  ),
                ),
                label: Text('Register New User', style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CurrentCampsPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(300, 40),
                ),
                icon: Padding(
                  padding: const EdgeInsets.only(left: 8.0), // Adjust the left padding as needed
                  child: SvgPicture.asset(
                    'assets/camp.svg',
                    color: Colors.white, // Set the color of the SVG
                    width: 24,
                    height: 24,
                  ),
                ),
                label: Text('Current Camps', style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  // Handle register button press
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(300, 40),
                ),
                icon: Padding(
                  padding: const EdgeInsets.only(left: 8.0), // Adjust the left padding as needed
                  child: SvgPicture.asset(
                    'assets/lab.svg',
                    color: Colors.white, // Set the color of the SVG
                    width: 24,
                    height: 24,
                  ),
                ),
                label: Text('Ongoing Tests', style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  // Handle register button press
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(300, 40),
                ),
                icon: Padding(
                  padding: const EdgeInsets.only(left: 8.0), // Adjust the left padding as needed
                  child: SvgPicture.asset(
                    'assets/vaccination.svg',
                    color: Colors.white, // Set the color of the SVG
                    width: 24,
                    height: 24,
                  ),
                ),
                label: Text('Ongoing Vaccinations', style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  // Handle register button press
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(300, 40),
                ),
                icon: Padding(
                  padding: const EdgeInsets.only(left: 8.0), // Adjust the left padding as needed
                  child: SvgPicture.asset(
                    'assets/doctor.svg',
                    color: Colors.white, // Set the color of the SVG
                    width: 24,
                    height: 24,
                  ),
                ),
                label: Text('Available Doctors', style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
