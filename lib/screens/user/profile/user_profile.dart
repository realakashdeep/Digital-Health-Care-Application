
import 'package:final_year_project/screens/user/user_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../constants/text_strings.dart';
import '../../../models/user_model.dart';
import '../../../services/user_services.dart';
import '../../welcome.dart';
import 'edit_profile.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final UserService _userService = UserService();
   MyUser? _user;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      MyUser? user = await _userService.getUser(userId!);
      if (user != null) {
        setState(() {
          _user = user;
        });
      } else {
        // Handle case where user data is not found
      }
    } catch (e) {
      throw(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(tProfile),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _user != null ? _buildUserProfile() : _buildLoadingIndicator(),
    );
  }

  Widget _buildUserProfile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Profile photo (Replace with actual user photo)
          Container(
            width: 200.0,
            height: 200.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/rwd.jpeg'), // Replace with actual image
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20.0),

          // User name
          Text(
            _user!.name,
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),

          // Email (Replace with actual user email)
          buildUserInfo(tPhoneNumber, _user!.phoneNumber),
          const SizedBox(height: 10.0),

          // Gender (Replace with actual user gender)
          buildUserInfo(tGender, _user!.gender),
          const SizedBox(height: 10.0),

          // Address (Replace with actual user address)
          buildUserInfo(tAddress, _user!.district+" "+_user!.state),
          const SizedBox(height: 10.0),

          // Aadhar Number (Replace with actual user Aadhar number)
          buildUserInfo(tAadharNumber, _user!.aadhaarNumber),
          const SizedBox(height: 20.0),

          // Edit profile button
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfile()),
              );
            },
            child: const Text(tEditProfile),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          const SizedBox(height: 20.0),

          // Log out button (Implement logout functionality)
          ElevatedButton(
            onPressed: () async {
              _userService.signOut().then(
                      (value) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => UserLogin()),
                            (Route<dynamic> route) => false,
                      )
                );
            },
            child: const Text(tLogOut),
          ),


        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildUserInfo(String title, String value) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10.0),
        Text(value),
      ],
    );
  }
}
