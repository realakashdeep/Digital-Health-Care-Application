import 'package:flutter/material.dart';

import '../../models/doctors_model.dart';
import '../../services/doctor_services.dart';

class RegisterDoctorPage extends StatefulWidget {
  @override
  _RegisterDoctorPageState createState() => _RegisterDoctorPageState();
}

class _RegisterDoctorPageState extends State<RegisterDoctorPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _wardNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  final DoctorsService _doctorsService = DoctorsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Doctor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _wardNumberController,
                decoration: InputDecoration(labelText: 'Ward Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a ward number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Doctor doctor = Doctor(
                      name: _nameController.text,
                      email: _emailController.text,
                      wardNumber: _wardNumberController.text,
                      password: _passwordController.text,
                    );
                    await _doctorsService.addDoctor(doctor);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Doctor registered successfully')));
                    Navigator.pop(context);
                  }
                },
                child: Text('Register Doctor'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
