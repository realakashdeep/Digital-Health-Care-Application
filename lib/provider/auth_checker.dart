import 'package:final_year_project/screens/ward/care_givers/careGiversMenu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/user/user_home.dart';
import '../screens/ward/care_givers/appointment_list.dart';
import '../screens/ward/doctors/doctorsMenuPage.dart';
import '../screens/ward/ward_menu.dart';
import '../screens/welcome.dart';
import 'auth_provider.dart' as MyAuthProvider;

class AuthChecker extends StatefulWidget {
  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<MyAuthProvider.AuthProvider>(context);

    return StreamBuilder<User?>(
      stream: authProvider.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData) {
          return FutureBuilder<String?>(
            future: _getUserType(snapshot.data),
            builder: (context, userTypeSnapshot) {
              if (userTypeSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (userTypeSnapshot.hasData) {
                final userType = userTypeSnapshot.data;
                if (userType == 'user') {
                  return UserHome();
                } else if (userType == 'ward') {
                  return WardMenuPage();
                }
                else if(userType == 'caregiver'){
                  print("returning caregiver");
                  return CareGiverMenuPage();
                }
                else if(userType == 'doctor'){
                  return DoctorsMenuPage();
                }
                else {
                  return WelcomePage();
                }
              } else {
                return WelcomePage();
              }
            },
          );
        } else {
          return WelcomePage();
        }
      },
    );
  }

  Future<String?> _getUserType(User? user) async {
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
        DocumentSnapshot wardDoc = await FirebaseFirestore.instance.collection('Wards').doc(user.uid).get();
        DocumentSnapshot caregiverDoc = await FirebaseFirestore.instance.collection('caregivers').doc(user.uid).get();
        DocumentSnapshot doctorDoc = await FirebaseFirestore.instance.collection('doctors').doc(user.uid).get();

        if (userDoc.exists) {
          Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
          if (userData != null && userData.containsKey('phoneNumber')) {
            return 'user';
          }
        }

        if (wardDoc.exists) {
          Map<String, dynamic>? wardData = wardDoc.data() as Map<String, dynamic>?;
          if (wardData != null && wardData.containsKey('wardId')) {
            return 'ward';
          }
        }

        if (caregiverDoc.exists) {
          Map<String, dynamic>? caregiverData = caregiverDoc.data() as Map<String, dynamic>?;
          if(caregiverData == null)
            print("null");
          if (caregiverData != null && caregiverData.containsKey('isCaregiver')) {
            return 'caregiver';
          }
        }

        if (doctorDoc.exists) {
          Map<String, dynamic>? doctorData = doctorDoc.data() as Map<String, dynamic>?;
          if (doctorData != null && doctorData.containsKey('isDoctor')) {
            return 'doctor';
          }
        }

        return null;
      } catch (e) {
        print('Error fetching user type: $e');
        return null;
      }
    }
    return null;
  }


}
