import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constants/text_strings.dart';
import '../../../models/user_model.dart';
import '../../../services/user_services.dart';
import '../../welcome.dart';
import 'edit_profile.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final UserService _userService = UserService();
  MyUser? _user;
  File? _imageFile;
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
      }
    } catch (e) {
      throw(e);
    }
  }

  @override
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
      body: RefreshIndicator(
        onRefresh: _fetchUserData, // Function to call when refreshing
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // Enable scrolling even when there's not enough content
          child: _user != null ? _buildUserProfile() : _buildLoadingIndicator(),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfile(user: _user, userService: _userService)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(150, 40),
                ),
                icon: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                label: const Text('Edit Profile', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            SizedBox(width: 20), // Space between the buttons
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  _showLogoutConfirmationDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(150, 40),
                ),
                icon: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                label: const Text('Log Out', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            width: 150.0,
            height: 150.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
              image: _imageFile != null
                  ? DecorationImage(
                image: FileImage(_imageFile!),
                fit: BoxFit.cover,
              )
                  : _user?.profilePictureURL != null
                  ? DecorationImage(
                image: NetworkImage(_user!.profilePictureURL!),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            child: Stack(
              children: [
                if (_user!.profilePictureURL == null)
                  Center(
                    child: Icon(
                      Icons.account_circle,
                      size: 100.0,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20.0),

          // User name
          Text(
            _user!.name,
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15.0),

          buildUserInfo('Phone Number', _user!.phoneNumber),
          const SizedBox(height: 10.0),

          buildUserInfo('Gender', _user!.gender),
          const SizedBox(height: 10.0),

          buildUserInfo('Ward', 'Ward ' + _user!.ward),
          const SizedBox(height: 10.0),

          buildUserInfo(tAddress, _user!.district + ", " + _user!.state),
          const SizedBox(height: 10.0),

          buildUserInfo('Aadhaar Number', _user!.aadhaarNumber),
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

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Are you sure you want to log out?', style: TextStyle(fontSize: 20, color: Colors.black)),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Colors.blue,
              ),
              child: Text('No', style: TextStyle(fontSize: 14, color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _userService.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomePage()),
                      (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Colors.redAccent,
              ),
              child: Text('Yes', style: TextStyle(fontSize: 14, color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
