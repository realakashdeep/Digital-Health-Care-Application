import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/care_givers_auth_provider.dart';

class CareGiversMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Care Giver\'s Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome, Care Giver!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the care giver's profile page or another functionality
              },
              child: Text('View Profile'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to another care giver's functionality
              },
              child: Text('View Patients'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Log out the care giver
                await Provider.of<CareGiversAuthProvider>(context, listen: false).signOut();
                Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
              },
              child: Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
