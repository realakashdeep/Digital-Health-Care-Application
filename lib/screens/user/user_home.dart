import 'package:final_year_project/constants/text_strings.dart';
import 'package:final_year_project/screens/user/health_centre_details.dart';
import 'package:final_year_project/screens/user/patient_appointment_report.dart';
import 'package:final_year_project/screens/user/profile/ViewCamps.dart';
import 'package:final_year_project/screens/user/profile/user_profile.dart';
import 'package:flutter/material.dart';

class UserHome extends StatelessWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          tHome,
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.1,
          vertical: screenSize.height * 0.06,
        ),
        child: Column(
          children: [
            const SizedBox(height: 15),
            Expanded(
              child: GridView.count(
                crossAxisCount: screenSize.width > 600 ? 4 : 2,
                crossAxisSpacing: screenSize.width * 0.05,
                mainAxisSpacing: screenSize.height * 0.03,
                children: <Widget>[
                  _buildSquareButton(
                    context,
                    icon: Icons.account_circle_rounded,
                    label: 'View Profile',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserProfile()),
                      );
                    },
                  ),
                  _buildSquareButton(
                    context,
                    icon: Icons.local_hospital,
                    label: 'HealthCare Details',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WardDetailsPage2()),
                      );
                    },
                  ),
                  _buildSquareButton(
                    context,
                    icon: Icons.campaign,
                    label: 'View Ongoing Camps',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ViewCamps()),
                      );
                    },
                  ),
                  _buildSquareButton(
                    context,
                    icon: Icons.list,
                    label: 'Appointments Report',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PatientAppointmentReport()),
                      );
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
            Icon(icon, size: 45.0, color: Colors.white), // Icon size and color
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
