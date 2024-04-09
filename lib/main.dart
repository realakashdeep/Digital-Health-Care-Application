import 'package:final_year_project/screens/user/user_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:final_year_project/provider/auth_provider.dart' as MyAppAuthProvider;
import 'package:provider/provider.dart';

import 'screens/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppAuthProvider.AuthProvider(), // Provide your AuthProvider
      child: MaterialApp(
        title: 'Digital Health Application',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: UserSignUp(), // Use UserSignUp as the initial screen
      ),
    );
  }
}
