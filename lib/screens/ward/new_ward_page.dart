import 'package:final_year_project/screens/ward/ward_menu.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../models/ward_model.dart';

class NewWardForm extends StatefulWidget {

  final WardModel ward;

  NewWardForm({required this.ward});
  @override
  _NewWardFormState createState() => _NewWardFormState();
}

class _NewWardFormState extends State<NewWardForm> {
  late TextEditingController _wardEmailController;
  late TextEditingController _wardAddressController;
  late TextEditingController _wardPasswordController;
  late TextEditingController _wardNumberController;
  late TextEditingController _wardSubtitleController;
  late TextEditingController _wardSummaryController;
  late TextEditingController _wardContactNumberController;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _wardEmailController = TextEditingController(text: widget.ward.wardEmail);
    _wardAddressController = TextEditingController(text: widget.ward.wardAddress);
    _wardPasswordController = TextEditingController(text: widget.ward.wardPassword);
    _wardNumberController = TextEditingController(text: widget.ward.wardNumber);
    _wardSubtitleController = TextEditingController(text: widget.ward.wardSubtitle);
    _wardSummaryController = TextEditingController(text: widget.ward.wardSummary);
    _wardContactNumberController = TextEditingController(text: widget.ward.wardContactNumber);
  }

  @override
  void dispose() {
    _wardEmailController.dispose();
    _wardAddressController.dispose();
    _wardPasswordController.dispose();
    _wardNumberController.dispose();
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
    String? imageUrl;
    try{

      if (_imageFile != null) {
        final storageRef = FirebaseStorage.instance.ref().child('ward_images').child(widget.ward.wardId + '.jpg');
        await storageRef.putFile(_imageFile!);
        imageUrl = await storageRef.getDownloadURL();
      }

      widget.ward.wardEmail = _wardEmailController.text;
      widget.ward.wardAddress = _wardAddressController.text;
      widget.ward.wardPassword = _wardPasswordController.text;
      widget.ward.wardNumber = _wardNumberController.text;
      widget.ward.wardSubtitle = _wardSubtitleController.text;
      widget.ward.wardSummary = _wardSummaryController.text;
      widget.ward.wardContactNumber = _wardContactNumberController.text;

      if (imageUrl != null) {
        widget.ward.wardImageUrl = imageUrl;
      }

      await FirebaseFirestore.instance.collection('Wards').doc(widget.ward.wardId).set(widget.ward.toJson());
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WardMenuPage()),
            (route)=>false,
      );
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save data : Error + $e')),
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
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
                  image: _imageFile != null ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover,)
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
            _buildTextField(label: 'Ward Email', controller: _wardEmailController),
            SizedBox(height: 16),
            _buildTextField(label: 'Ward Address', controller: _wardAddressController),
            SizedBox(height: 16),
            _buildTextField(label: 'Ward Password', controller: _wardPasswordController, obscureText: true),
            SizedBox(height: 16),
            _buildTextField(label: 'Ward Number', controller: _wardNumberController),
            SizedBox(height: 16),
            _buildTextField(label: 'Ward Subtitle', controller: _wardSubtitleController),
            SizedBox(height: 16),
            _buildTextField(label: 'Ward Summary', controller: _wardSummaryController, maxLines: 4),
            SizedBox(height: 16),
            _buildTextField(label: 'Ward Contact Number', controller: _wardContactNumberController),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _uploadImageAndSaveWardDetails,
              child: Text('Save'),
            ),
          ],
        ),
      ),
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
    );
  }
}
