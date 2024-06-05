import 'package:final_year_project/models/user_model.dart';
import 'package:final_year_project/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/ward_model.dart';
import '../../provider/ward_user_provider.dart';

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
            setState(() {
              _ward = wardModel;
              _isLoading = false;
            });
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
    setState(() {
      _isLoading = false;
      _errorMessage = message;
    });
  }

  Future<void> _updateWard() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final wardUserProvider = Provider.of<WardUserProvider>(context, listen: false);
      await wardUserProvider.updateUser(_ward);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
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
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _buildListTile('Email', _ward.wardEmail),
              _buildListTile('Address', _ward.wardAddress),
              _buildListTile('Number', _ward.wardNumber),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateWard,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(String title, String subtitle) {
    return ListTile(
      title: Text(title, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
    );
  }
}
