import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/models/ward_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../models/doctors_model.dart';

class DoctorProfile extends StatefulWidget {
  @override
  _DoctorProfileState createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Doctor? _doctor;
  WardModel? wardModel;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDoctorDetails();
  }

  Future<void> _fetchDoctorDetails() async {
    User? user = firebaseAuth.currentUser;
    if (user != null) {
      try {
        QuerySnapshot<Map<String, dynamic>> doctorSnapshot =
        await FirebaseFirestore.instance
            .collection("doctors")
            .where("email", isEqualTo: user.email)
            .limit(1)
            .get();

        if (doctorSnapshot.docs.isNotEmpty) {
          setState(() {
            _doctor = Doctor.fromMap(doctorSnapshot.docs.first.data());
            _fetchWardDetails(); // Fetch ward details after doctor is loaded
          });
        } else {
          _setError('Doctor not found.');
        }
      } catch (e) {
        _setError('Error fetching doctor details: $e');
      }
    }
  }

  Future<void> _fetchWardDetails() async {
    if (_doctor != null) {
      try {
        QuerySnapshot<Map<String, dynamic>> wardSnapshot =
        await FirebaseFirestore.instance
            .collection("Wards")
            .where("wardNumber", isEqualTo: _doctor!.wardNumber)
            .limit(1)
            .get();

        if (wardSnapshot.docs.isNotEmpty) {
          setState(() {
            wardModel = WardModel.fromSnapshot(wardSnapshot.docs.first);
            _isLoading = false;
          });
        } else {
          _setError('Ward not found.');
        }
      } catch (e) {
        _setError('Error fetching ward details: $e');
      }
    }
  }

  void _setError(String message) {
    if (mounted) {
      setState(() {
        _isLoading = false;
        _errorMessage = message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Details'),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
        child: Text(
          _errorMessage!,
          style: TextStyle(color: Colors.red),
        ),
      )
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (_doctor != null)
              _buildDoctorInfoCard(_doctor!),
            SizedBox(height: 16),
            if (wardModel != null)
              _buildWardDetailsSection(
                  wardModel!), // Use fetched ward data
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorInfoCard(Doctor doctor) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 40,
                  backgroundImage: doctor.doctorImageUrl.isNotEmpty
                      ? NetworkImage(doctor.doctorImageUrl)
                      : NetworkImage('https://via.placeholder.com/80'),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        doctor.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('MBBS, MD'), // Example specialization - replace
                      Text('Nephrologist'), // Example specialization - replace
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 4),
                          Text('4.5 rating'), // Replace with actual rating
                        ],
                      ),
                      SizedBox(height: 8),
                      Text('12 Year Experience'), // Replace with actual experience
                      Text(
                        '${doctor.wardNumber} Ward',
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'About Doctor',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(doctor.aboutDoctor),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle Update button press
                      // Implement update logic using Firestore
                    },
                    child: Text('Update Profile'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWardDetailsSection(WardModel ward) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ward Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.confirmation_number),
              title: Text('Ward Number'),
              subtitle: Text(ward.wardNumber),
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Ward Address'),
              subtitle: Text(ward.wardAddress),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Ward Contact'),
              subtitle: Text(ward.wardContactNumber),
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text('Ward Subtitle'),
              subtitle: Text(ward.wardSubtitle),
            ),
          ],
        ),
      ),
    );
  }
}
