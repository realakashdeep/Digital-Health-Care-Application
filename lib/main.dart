import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'constants/text_strings.dart';
import 'provider/auth_provider.dart' as MyAuthProvider; // Alias your AuthProvider
import 'screens/splash_screen.dart';
import 'screens/user/user_signup.dart';
import 'screens/user/user_home.dart';
import 'screens/user/profile/user_profile.dart';
import 'screens/welcome.dart';
import 'firebase_options.dart';
import 'provider/auth_checker.dart'; // Import AuthChecker

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyAuthProvider.AuthProvider(), // Use the aliased name
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: tTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/auth_checker': (context) => AuthChecker(),
        '/user_home': (context) => UserHome(),
        '/user_profile': (context) => UserProfile(),
        '/welcome': (context) => WelcomePage(),
      },
    );
  }
}
