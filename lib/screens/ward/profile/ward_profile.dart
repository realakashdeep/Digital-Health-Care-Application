
import 'package:final_year_project/screens/ward/profile/ward_update_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/ward_model.dart';
import '../../../provider/ward/ward_user_provider.dart';

class WardProfilePage extends StatefulWidget {
  @override
  _WardProfilePageState createState() => _WardProfilePageState();
}

class _WardProfilePageState extends State<WardProfilePage> {
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
      final wardUserProvider = Provider.of<WardUserProvider>(
          context, listen: false);
      String? userId = await wardUserProvider.getCurrentUserId();
      if (userId != null) {
        await wardUserProvider.fetchUser(userId);
        setState(() {
          _ward = wardUserProvider.user!;
          _isLoading = false;
        });
      } else {
        _setError(
            'Error: Unable to fetch user ID. Please try logging in again.');
      }
    }
    catch(e){
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
                      child: SizedBox(
                        width: 400,
                        height: 200,
                        child: _ward.wardImageUrl != 'N/A' ? Image.network(_ward.wardImageUrl, fit: BoxFit.cover) : Image.network('https://via.placeholder.com/400x200', fit: BoxFit.cover,),
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
                            _ward.wardSubtitle,
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
                              Text(_ward.wardNumber),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => WardUpdateProfile(ward: _ward))
                                  );
                                },
                                child: Text('Update'),
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
              _ward.wardSummary
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
