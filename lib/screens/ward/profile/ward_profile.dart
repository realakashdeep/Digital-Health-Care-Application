import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_year_project/provider/doctor/doctor_provider.dart';
import 'package:final_year_project/provider/ward/ward_user_provider.dart';
import 'package:final_year_project/models/doctors_model.dart';
import 'package:final_year_project/models/ward_model.dart';
import 'ward_update_profile.dart';

class WardProfilePage extends StatefulWidget {
  @override
  _WardProfilePageState createState() => _WardProfilePageState();
}

class _WardProfilePageState extends State<WardProfilePage> {
  late WardModel _ward;
  bool _isLoading = true;
  String? _errorMessage;
  List<Doctor> _doctors = [];

  @override
  void initState() {
    super.initState();
    _fetchWard();
  }

  Future<void> _fetchWard() async {
    try {
      final wardUserProvider = Provider.of<WardUserProvider>(context, listen: false);
      String? userId = await wardUserProvider.getCurrentUserId();
      if (userId != null) {
        await wardUserProvider.fetchUser(userId);
        setState(() {
          _ward = wardUserProvider.user!;
          _isLoading = false;
        });
        _fetchDoctors();
      } else {
        _setError(
            'Error: Unable to fetch user ID. Please try logging in again.');
      }
    } catch (e) {
      _setError('Error: $e');
    }
  }

  Future<void> _fetchDoctors() async {
    try {
      final doctorProvider = Provider.of<DoctorsProvider>(context, listen: false);
      await doctorProvider.fetchDoctorsByWardNumber(_ward.wardNumber);
      setState(() {
        _doctors = doctorProvider.doctors;
      });
    } catch (e) {
      _setError('Error: $e');
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
        title: Text('Ward Details'),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
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
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                    child: SizedBox(
                      width: 400,
                      height: 200,
                      child: _ward.wardImageUrl != 'N/A'
                          ? Image.network(_ward.wardImageUrl,
                          fit: BoxFit.cover)
                          : Image.network(
                        'https://via.placeholder.com/400x200',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Ward ${_ward.wardNumber}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: <Widget>[
                            Icon(Icons.location_on,
                                color: Colors.grey),
                            SizedBox(width: 4),
                            Text(_ward.wardAddress),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: <Widget>[
                            Icon(Icons.phone, color: Colors.grey),
                            SizedBox(width: 4),
                            Text(_ward.wardContactNumber),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Doctors',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _doctors.length,
              itemBuilder: (context, index) {
                final doctor = _doctors[index];
                return _buildCard(doctor: doctor);
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WardUpdateProfile(ward: _ward),
                  ),
                );
              },
              child: Text('Update'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Doctor doctor}) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: doctor.doctorImageUrl.isEmpty ? NetworkImage('https://via.placeholder.com/50') :NetworkImage(doctor.doctorImageUrl),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Dr "+doctor.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              "Number : "+doctor.doctorContactNumber,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              "Mail : "+doctor.email,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
