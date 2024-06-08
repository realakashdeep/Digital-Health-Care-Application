import 'package:final_year_project/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/doctors_model.dart';
import '../../models/ward_model.dart';
import '../../provider/doctor/doctor_provider.dart';
import '../../provider/user/user_provider.dart';
import '../../provider/ward/ward_user_provider.dart';

class WardDetailsPage2 extends StatefulWidget {
  @override
  _WardProfilePageState createState() => _WardProfilePageState();
}


class _WardProfilePageState extends State<WardDetailsPage2> {
  late WardModel _ward;
  bool _isLoading = true;
  String? _errorMessage;
  List<Doctor> _doctors = [];

  @override
  void initState() {
    super.initState();
    _fetchWardAndDoctors();
  }

  Future<void> _fetchWardAndDoctors() async {
    try {
      final wardUserProvider = Provider.of<WardUserProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final doctorProvider = Provider.of<DoctorsProvider>(context, listen: false);

      String? userId = await userProvider.getCurrentUserId();
      if (userId != null) {
        await userProvider.fetchUser(userId);
        MyUser? user = userProvider.user;

        if (user != null) {
          int wardNumber = int.parse(user.ward);

          // Fetch ward details
          await wardUserProvider.getWardByNumber(wardNumber.toString());
          WardModel? wardModel = wardUserProvider.user;

          // Fetch doctors for the ward
          await doctorProvider.fetchDoctorsByWardNumber(wardNumber.toString());

          if (wardModel != null) {
            if (mounted) {
              setState(() {
                _ward = wardModel;
                _doctors = doctorProvider.doctors; // Assign fetched doctors
                _isLoading = false;
              });
            }
          } else {
            _setError('Unable to fetch Ward. Please try again.');
          }
        } else {
          _setError('Unable to fetch user. Please try again.');
        }
      } else {
        _setError('Unable to fetch user ID. Please try logging in again.');
      }
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
                border: Border.all(
                  width: 1
                ),
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
              physics: NeverScrollableScrollPhysics(), // Prevent scrolling conflicts
              itemCount: _doctors.length,
              itemBuilder: (context, index) {
                final doctor = _doctors[index];
                return _buildCard(doctor: doctor);
              },
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
