import 'package:final_year_project/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../provider/ward_auth_provider.dart';
import 'CurrentCampsPage.dart';
import 'RegisterUserPage.dart';

class WardMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wardAuthProvider = Provider.of<WardAuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Ward Menu'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Ward Menu',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 40),
                buildMenuButton(
                  context,
                  'Register New User',
                  'assets/add_user.svg',
                  RegisterUserPage(),
                ),
                SizedBox(height: 12),
                buildMenuButton(
                  context,
                  'Current Camps',
                  'assets/camp.svg',
                  CurrentCampsPage(),
                ),
                SizedBox(height: 12),
                buildMenuButton(
                  context,
                  'Ongoing Tests',
                  'assets/lab.svg',
                  null, // Replace with appropriate page
                ),
                SizedBox(height: 12),
                buildMenuButton(
                  context,
                  'Ongoing Vaccinations',
                  'assets/vaccination.svg',
                  null, // Replace with appropriate page
                ),
                SizedBox(height: 12),
                buildMenuButton(
                  context,
                  'Available Doctors',
                  'assets/doctor.svg',
                  null, // Replace with appropriate page
                ),
                SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () async {
                    await wardAuthProvider.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: Size(300, 40),
                  ),
                  icon: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  label: Text('Logout', style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMenuButton(BuildContext context, String label, String assetPath, Widget? page) {
    return ElevatedButton.icon(
      onPressed: () {
        if (page != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        minimumSize: Size(300, 40),
      ),
      icon: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: SvgPicture.asset(
          assetPath,
          color: Colors.white,
          width: 24,
          height: 24,
        ),
      ),
      label: Text(label, style: TextStyle(color: Colors.white, fontSize: 20)),
    );
  }
}
