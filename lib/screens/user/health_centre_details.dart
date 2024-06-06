import 'package:final_year_project/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/ward_model.dart';
import '../../provider/user/user_provider.dart';
import '../../provider/ward/ward_user_provider.dart';

class HealthCentreDetailsPage extends StatefulWidget {
  @override
  _HealthCentreDetailsPageState createState() => _HealthCentreDetailsPageState();
}

class _HealthCentreDetailsPageState extends State<HealthCentreDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  late WardModel _ward;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchWard();
  }

  Future<void> _fetchWard() async {
    try {
      final wardUserProvider = Provider.of<WardUserProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      String? userId = await userProvider.getCurrentUserId();
      if (userId != null) {
        await userProvider.fetchUser(userId);
        MyUser? user = userProvider.user;

        if (user != null) {
          int wardNumber = int.parse(user.ward);
          await wardUserProvider.getWardByNumber(wardNumber.toString());
          WardModel? wardModel = wardUserProvider.user;

          if (wardModel != null) {
            if (mounted) {
              setState(() {
                _ward = wardModel;
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
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!, style: TextStyle(color: Colors.red)))
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
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 5,
                    child: Column(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                          child: Image.network(
                            'https://via.placeholder.com/400x200',
                            fit: BoxFit.cover,
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
                              Text(
                                'Subtitle',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.location_on, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text(_ward.wardAddress),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.directions_walk, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text('5km Away From Your Location'),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      // Handle View All Doctors button press
                                    },
                                    child: Text('View All Doctors'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      // Handle Call button press
                                    },
                                    child: Text('Call'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.blue, side: BorderSide(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'About Ward',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'A career as a doctor is a clinical professional that involves providing services in healthcare facilities. Individuals in the doctor’s career path are responsible for diagnosing, examining, and identifying diseases, disorders, and illnesses of patients.',
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
                _buildCard(
                  name: 'Sam Curren',
                  date: '12/3/2023',
                  review: 'Responsible for diagnosing, examining, and identifying diseases, disorders, and illnesses of patients.',
                ),
                _buildCard(
                  name: 'Sam Curren',
                  date: '12/3/2023',
                  review: 'Responsible for diagnosing, examining, and identifying diseases, disorders, and illnesses of patients.',
                ),
                // Add more reviews as needed
              ],
            ),
          ),
      );
    }
  
  Widget _buildCard({required String name, required String date, required String review}) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage('https://via.placeholder.com/50'),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(date, style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        subtitle: Text(review),
      ),
    );
  }
}
