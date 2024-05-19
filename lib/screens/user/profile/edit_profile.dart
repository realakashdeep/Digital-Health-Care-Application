import 'package:final_year_project/constants/image_strings.dart';
import 'package:final_year_project/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController(text: 'Robert Downey Jr');
  final TextEditingController _emailController = TextEditingController(text: 'robert.downeyjr@example.com');
  final TextEditingController _genderController = TextEditingController(text: 'Male');
  final TextEditingController _addressController = TextEditingController(text: '123 Main Street, Anytown, CA');
  final TextEditingController _aadharController = TextEditingController(text: '1234 5678 9012');
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tEditProfile),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildProfileImage(),
            SizedBox(height: 20.0),
            _buildTextField(controller: _nameController, labelText: tName),
            SizedBox(height: 10.0),
            _buildTextField(controller: _emailController, labelText: tPhoneNumber, keyboardType: TextInputType.phone),
            SizedBox(height: 10.0),
            _buildTextField(controller: _genderController, labelText: tGender),
            SizedBox(height: 10.0),
            _buildTextField(controller: _addressController, labelText: tAddress, maxLines: null),
            SizedBox(height: 10.0),
            _buildTextField(controller: _aadharController, labelText: tAadharNumber, keyboardType: TextInputType.number),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Handle saving edited profile information
              },
              child: Text(tSaveProfile),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 150.0,
      height: 150.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: _imageFile == null ? const AssetImage(ImgProfile) : FileImage(_imageFile!) as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: _pickImage,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    int? maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }
}
