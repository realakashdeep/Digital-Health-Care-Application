import 'package:final_year_project/otp_test/phone_auth.dart';
import 'package:final_year_project/screens/user/user_otp.dart';
import 'package:final_year_project/screens/user/user_signup.dart';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void>  main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("assets/login_user_image.jpg"), context);
    return MaterialApp(
      title: 'Digital Health Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: UserSignUp(), // Use SplashScreen as the initial screen
    );
  }
}
