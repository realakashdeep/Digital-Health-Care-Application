import 'package:final_year_project/constants/text_strings.dart';
import 'package:final_year_project/screens/user/profile/user_profile.dart';
import 'package:final_year_project/screens/welcome.dart'; // Import the WelcomePage
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserHome extends StatelessWidget {
  const UserHome({Key? key}) : super(key: key); // Added the 'key' parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(tHome),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          children: <Widget>[
            _buildSquareButton(
              context,
              icon: Icons.account_circle_rounded,
              label: 'Profile',
              onPressed: () {
                // Navigate to the UserProfile page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfile()),
                );
              },
            ),
            // Other buttons omitted for brevity
            _buildSquareButton(
              context,
              icon: Icons.info,
              label: 'Info',
              onPressed: () {
                // Define your function here
                print('Info button pressed');
              },
            ),
            // Log out button
            _buildSquareButton(
              context,
              icon: Icons.logout,
              label: 'Log Out',
              onPressed: () async {
                // Sign out the user
                await FirebaseAuth.instance.signOut();

                // Navigate to the welcome page and remove all previous routes from the stack
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomePage()),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareButton(BuildContext context,
      {required IconData icon,
        required String label,
        required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 48.0),
          const SizedBox(height: 8.0),
          Text(label, style: const TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }
}
