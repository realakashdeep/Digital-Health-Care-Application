import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:final_year_project/provider/auth_provider.dart' as MyAppAuthProvider;
import 'package:provider/provider.dart';

import 'screens/splash_screen.dart';
import 'screens/user/user_signup.dart'; // Import the UserSignUp screen
import 'screens/user/user_home.dart'; // Import the UserHome screen

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppAuthProvider.AuthProvider(),
      child: MaterialApp(
        title: 'Digital Health Application',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/user_home': (context) => UserHome(),
        },
      ),
    );
  }
}
