import 'package:final_year_project/screens/ward/ward_menu.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../models/ward_model.dart';

class WardUpdateProfile extends StatefulWidget {
  final WardModel ward;

  WardUpdateProfile({required this.ward});
  @override
  _WardUpdateProfileState createState() => _WardUpdateProfileState();
}

class _WardUpdateProfileState extends State<WardUpdateProfile> {
  late TextEditingController _wardAddressController;
  late TextEditingController _wardPasswordController;
  late TextEditingController _wardSubtitleController;
  late TextEditingController _wardSummaryController;
  late TextEditingController _wardContactNumberController;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>(); // Add form key for validation

  @override
  void initState() {
    super.initState();
    _wardAddressController = TextEditingController(text: widget.ward.wardAddress);
    _wardPasswordController = TextEditingController(text: widget.ward.wardPassword);
    _wardSubtitleController = TextEditingController(text: widget.ward.wardSubtitle);
    _wardSummaryController = TextEditingController(text: widget.ward.wardSummary);
    _wardContactNumberController = TextEditingController(text: widget.ward.wardContactNumber);
  }

  @override
  void dispose() {
    _wardAddressController.dispose();
    _wardPasswordController.dispose();
    _wardSubtitleController.dispose();
    _wardSummaryController.dispose();
    _wardContactNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _uploadImageAndSaveWardDetails() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String? imageUrl;
    try {
      if (_imageFile != null) {
        final storageRef = FirebaseStorage.instance.ref().child('ward_images').child(widget.ward.wardId + '.jpg');
        await storageRef.putFile(_imageFile!);
        imageUrl = await storageRef.getDownloadURL();
      }

      widget.ward.wardAddress = _wardAddressController.text;
      widget.ward.wardPassword = _wardPasswordController.text;
      widget.ward.wardSubtitle = _wardSubtitleController.text;
      widget.ward.wardSummary = _wardSummaryController.text;
      widget.ward.wardContactNumber = _wardContactNumberController.text;

      if (imageUrl != null) {
        widget.ward.wardImageUrl = imageUrl;
      }

      await FirebaseFirestore.instance.collection('Wards').doc(widget.ward.wardId).update(widget.ward.toJson());
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WardMenuPage()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save data: Error + $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ward Details'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Add form key here
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                    image: _imageFile != null ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
                        : widget.ward.wardImageUrl != 'N/A'
                        ? DecorationImage(
                      image: NetworkImage(widget.ward.wardImageUrl),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: _imageFile == null && widget.ward.wardImageUrl == 'N/A'
                      ? Center(child: Text('Tap to add an image'))
                      : null,
                ),
              ),
              SizedBox(height: 16),
              _buildText(label: 'Ward Email', value: widget.ward.wardEmail),
              SizedBox(height: 16),
              _buildText(label: 'Ward Number', value: widget.ward.wardNumber),
              SizedBox(height: 16),
              _buildTextField(label: 'Ward Address', controller: _wardAddressController),
              SizedBox(height: 16),
              _buildTextField(label: 'Ward Contact Number', controller: _wardContactNumberController, keyboardType: TextInputType.phone),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _uploadImageAndSaveWardDetails,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildText({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + ": " + value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller, TextInputType keyboardType = TextInputType.text, int maxLines = 1, bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        if (label == 'Ward Contact Number') {
          if (value.length != 10) {
            return 'Mobile number must be 10 digits long';
          }
          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
            return 'Mobile number must contain only digits';
          }
        }
        return null;
      },
    );
  }
}
