import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'RegisterUserPage.dart';

class CurrentCampsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Current Camps'),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.black, size: 30),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/signup_user_image.jpg'), // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
              child: Text(
                'Digital HealthCare Facilities',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/add_user.svg', // Replace 'your_icon.svg' with your SVG asset path
                width: 24,
                height: 24,
                color: Colors.black,
              ),
              title: Text(
                'Register New User',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterUserPage()),
                );
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/camp.svg', // Replace 'your_icon.svg' with your SVG asset path
                width: 24,
                height: 24,
                color: Colors.black,
              ),
              title: Text(
                'Current Camps',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onTap: () {
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/lab.svg', // Replace 'your_icon.svg' with your SVG asset path
                width: 24,
                height: 24,
                color: Colors.black,
              ),
              title: Text('Ongoing Tests',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onTap: () {
                // Handle Option 3 press
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/vaccination.svg', // Replace 'your_icon.svg' with your SVG asset path
                width: 24,
                height: 24,
                color: Colors.black,
              ),
              title: Text('Ongoing Vaccinations',
                style: TextStyle(
                  fontSize: 20,
                ),),
              onTap: () {
                // Handle Option 4 press
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/doctor.svg', // Replace 'your_icon.svg' with your SVG asset path
                width: 24,
                height: 24,
                color: Colors.black,
              ),
              title: Text('Available Doctors',
                style: TextStyle(
                  fontSize: 20,
                ),),
              onTap: () {
                // Handle Option 5 press
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Divider(
            thickness: 1.0,
            color: Colors.black,
          ),
          // Rest of your page content goes here
        ],
      ),
    );
  }
}
