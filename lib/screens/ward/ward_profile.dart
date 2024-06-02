import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/ward_model.dart';
import '../../provider/ward_user_provider.dart';

class WardProfilePage extends StatefulWidget {
  @override
  _WardProfilePageState createState() => _WardProfilePageState();
}

class _WardProfilePageState extends State<WardProfilePage> {
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
    final wardUserProvider = Provider.of<WardUserProvider>(context, listen: false);
    String? userId = await wardUserProvider.getCurrentUserId();
    if (userId != null) {
      await wardUserProvider.fetchUser(userId);
      setState(() {
        _ward = wardUserProvider.user!;
        _isLoading = false;
      });
    } else {
      // Handle the case where userId is null
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: Unable to fetch user ID. Please try logging in again.';
      });
    }
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
          title: Text('Ward Profile Page'),
          centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _ward.wardEmail,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _ward.wardEmail = value!;
                },
              ),
              TextFormField(
                initialValue: _ward.wardAddress,
                decoration: InputDecoration(labelText: 'Address'),
                onSaved: (value) {
                  _ward.wardAddress = value!;
                },
              ),
              TextFormField(
                initialValue: _ward.wardPassword,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                onSaved: (value) {
                  _ward.wardPassword = value!;
                },
              ),
              TextFormField(
                initialValue: _ward.wardNumber,
                decoration: InputDecoration(labelText: 'Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _ward.wardNumber = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateWard,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

