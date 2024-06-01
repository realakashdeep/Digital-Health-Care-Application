import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/user/user_home.dart';
import '../screens/ward/ward_menu.dart';
import '../screens/welcome.dart';
import 'auth_provider.dart' as MyAuthProvider;

class AuthChecker extends StatelessWidget {
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
                } else {
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
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
      DocumentSnapshot userDoc2 = await FirebaseFirestore.instance.collection('Wards').doc(user.uid).get();
      if (userDoc.exists) {
        Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
        if (userData != null) {
          if (userData.containsKey('phoneNumber')) {
            return 'user';
          }
        }
      }
      if (userDoc2.exists) {
        Map<String, dynamic>? userData = userDoc2.data() as Map<String, dynamic>?;
        if (userData != null) {
          if (userData.containsKey('wardId')) {
            return 'ward';
          }
        }
      }
    }
    return null;
  }
}
