import 'package:final_year_project/constants/text_strings.dart';
import 'package:final_year_project/screens/user/profile/user_profile.dart';
import 'package:flutter/material.dart';

class UserHome extends StatelessWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(tHome),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 34.0),
        child: Column(
          children: [
            const SizedBox(height: 15),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 25.0,
                mainAxisSpacing: 30.0,
                children: <Widget>[
                  _buildSquareButton(
                    context,
                    icon: Icons.account_circle_rounded,
                    label: 'View Profile',
                    onPressed: () {
                      // Navigate to the UserProfile page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserProfile()),
                      );
                    },
                  ),
                  _buildSquareButton(
                    context,
                    icon: Icons.health_and_safety,
                    label: 'Get Your EHR',
                    onPressed: () {
                      // Define your function here
                      print('Get Your EHR button pressed');
                    },
                  ),
                  _buildSquareButton(
                    context,
                    icon: Icons.local_hospital,
                    label: 'Get HealthCare Details',
                    onPressed: () {
                      // Define your function here
                      print('Get HealthCare Details button pressed');
                    },
                  ),
                  _buildSquareButton(
                    context,
                    icon: Icons.campaign,
                    label: 'View Ongoing Camps',
                    onPressed: () {
                      // Define your function here
                      print('View Ongoing Camps button pressed');
                    },
                  ),
                ],
              ),
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
    return SizedBox(
      width: 80, // Reduced button width
      height: 120, // Reduced button height
      child: ElevatedButton(
        onPressed: onPressed,
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
            Icon(icon, size: 55.0, color: Colors.white), // Icon size and color
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
