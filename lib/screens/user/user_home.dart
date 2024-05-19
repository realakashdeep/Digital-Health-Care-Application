import 'package:final_year_project/constants/text_strings.dart';
import 'package:final_year_project/screens/user/profile/user_profile.dart';
import 'package:flutter/material.dart';

class UserHome extends StatelessWidget {
  const UserHome({super.key});

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
              icon: Icons.message,
              label: tProfile,
              onPressed: () {
                // Define your function here
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfile()),
                );
              },
            ),
            _buildSquareButton(
              context,
              icon: Icons.contacts,
              label: 'Contacts',
              onPressed: () {
                // Define your function here
                print('Contacts button pressed');
              },
            ),
            _buildSquareButton(
              context,
              icon: Icons.settings,
              label: 'Settings',
              onPressed: () {
                // Define your function here
                print('Settings button pressed');
              },
            ),
            _buildSquareButton(
              context,
              icon: Icons.info,
              label: 'Info',
              onPressed: () {
                // Define your function here
                print('Info button pressed');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onPressed}) {
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
