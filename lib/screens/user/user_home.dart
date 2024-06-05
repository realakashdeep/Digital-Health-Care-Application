import 'package:final_year_project/constants/text_strings.dart';
import 'package:final_year_project/models/health_record_model.dart';
import 'package:final_year_project/screens/user/health_centre_details.dart';
import 'package:final_year_project/screens/user/profile/ViewCamps.dart';
import 'package:final_year_project/screens/user/profile/user_profile.dart';
import 'package:final_year_project/screens/user/user_ehr_list.dart';
import 'package:final_year_project/screens/ward/care_givers/careGiversForm.dart';
import 'package:final_year_project/screens/ward/care_givers/appointment_list.dart';
import 'package:final_year_project/screens/ward/doctors/appointment.dart';
import 'package:final_year_project/screens/ward/patientInfoForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserHome extends StatelessWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
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
                        MaterialPageRoute(builder: (context) => HealthCentreDetailsPage()),
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
                    icon: Icons.campaign,
                    label: 'Add Basic HealthRecord',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PatientInfoForm()),
                      );
                    },
                  ),
                  _buildSquareButton(
                    context,
                    icon: Icons.campaign,
                    label: 'CareGivers Medical Form',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CareGiversForm()),
                      );
                    },
                  ),
                  _buildSquareButton(
                    context,
                    icon: Icons.campaign,
                    label: 'Doctor\'s Appointments',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AppointmentList()),
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
