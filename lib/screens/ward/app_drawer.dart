// app_drawer.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'RegisterUserPage.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/signup_user_image.jpg'),
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
              'assets/add_user.svg',
              width: 24,
              height: 24,
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
              'assets/camp.svg',
              width: 24,
              height: 24,
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
            leading: Icon(
              Icons.list_alt,
              size: 24,
              color: Colors.black,
            ),
            title: Text(
              'Generate Reports',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onTap: () {

              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(
              Icons.local_hospital_outlined,
              size: 24,
              color: Colors.black,
            ),
            title: Text(
              'Update HealthCentre',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onTap: () {
              Navigator.pop(context); // Close the drawer
            },
          )

        ],
      ),
    );
  }
}
