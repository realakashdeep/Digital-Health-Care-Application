import 'package:final_year_project/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../provider/ward_auth_provider.dart';
import 'CurrentCampsPage.dart';
import 'RegisterUserPage.dart';

class WardMenuPage extends StatefulWidget {
  @override
  State<WardMenuPage> createState() => _WardMenuPageState();
}

class _WardMenuPageState extends State<WardMenuPage> {
  @override
  Widget build(BuildContext context) {
    final wardAuthProvider = Provider.of<WardAuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Ward Representative'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 34.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(
                  'Ward Menu',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 40),
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                  children: <Widget>[
                    buildMenuButton(
                      context,
                      'Register New User',
                      'assets/add_user.svg',
                      RegisterUserPage(),
                    ),
                    buildMenuButton(
                      context,
                      'Camps Details',
                      'assets/camp.svg',
                      CurrentCampsPage(),
                    ),
                    buildMenuButtonWithIcon(
                      context,
                      'Update HealthCentre',
                      Icons.local_hospital,
                      null,
                    ),
                    buildMenuButtonWithIcon(
                      context,
                      'Generate Reports',
                      Icons.list_alt,
                      null,
                    ),
                  ],
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 34.0),
        child: ElevatedButton.icon(
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
      ),
    );
  }

  Widget buildMenuButton(BuildContext context, String label, String assetPath, Widget? page) {
    return SizedBox(
      width: 80, // Reduced button width
      height: 120, // Reduced button height
      child: ElevatedButton(
        onPressed: () {
          if (page != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // Button color
          padding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              assetPath,
              color: Colors.white,
              width: 55, // Icon size
              height: 55, // Icon size
            ),
            const SizedBox(height: 8.0),
            Text(
              label,
              style: const TextStyle(fontSize: 16.0, color: Colors.white), // Text size and color
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuButtonWithIcon(BuildContext context, String label, IconData icon, Widget? page) {
    return SizedBox(
      width: 80, // Reduced button width
      height: 120, // Reduced button height
      child: ElevatedButton(
        onPressed: () {
          if (page != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // Button color
          padding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 55,
              color: Colors.white, // Icon color
            ),
            const SizedBox(height: 8.0),
            Text(
              label,
              style: const TextStyle(fontSize: 16.0, color: Colors.white), // Text size and color
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
