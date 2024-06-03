import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/doctors_auth_provider.dart';

class DoctorsMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor\'s Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome, Doctor!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the doctor's profile page or another functionality
              },
              child: Text('View Profile'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to another doctor's functionality
              },
              child: Text('View Appointments'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Log out the doctor
                await Provider.of<DoctorsAuthProvider>(context, listen: false).signOut();
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
              child: Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
