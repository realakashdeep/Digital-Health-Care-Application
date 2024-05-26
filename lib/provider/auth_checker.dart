import 'package:final_year_project/screens/ward/ward_menu.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:final_year_project/provider/auth_provider.dart' as MyAuthProvider;
import 'package:final_year_project/screens/user/user_home.dart';
import 'package:final_year_project/screens/welcome.dart';

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
          if(snapshot.data?.email == null){
            return UserHome();
          }
            return WardMenuPage();
        } else {
          return WelcomePage();
        }
      },
    );
  }
}
