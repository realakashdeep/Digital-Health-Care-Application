import 'package:final_year_project/provider/ward_user_provider.dart';
import 'package:final_year_project/screens/ward/ward_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/ward_auth_provider.dart';
import '../../provider/care_givers_auth_provider.dart';
import '../../provider/doctors_auth_provider.dart';
import 'care_givers/careGiversMenu.dart';
import 'doctors/doctorsMenuPage.dart';

class WardLoginPage extends StatefulWidget {
  @override
  _WardLoginPageState createState() => _WardLoginPageState();
}

class _WardLoginPageState extends State<WardLoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;
  bool _obscureText = true; // Initially obscure the password
  String _selectedRole = 'Ward'; // Default selected role

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Digital HealthCare Facilities'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 22),
                  Text(
                    'Login',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 40),
                  // Dropdown menu
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    items: <String>['Ward', 'Care Givers', 'Doctor']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRole = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Log In As',
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  buildTextField(_emailController, 'Email', 'Enter Email'),
                  SizedBox(height: 16),
                  buildTextField(_passwordController, 'Password', 'Enter Password', obscureText: _obscureText),
                  SizedBox(height: 30),
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });

                        try {
                          switch (_selectedRole) {
                            case 'Ward':
                              await _handleWardLogin(context);
                              break;
                            case 'Care Givers':
                              await _handleCareGiversLogin(context);
                              break;
                            case 'Doctor':
                              await _handleDoctorLogin(context);
                              break;
                          }
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Login failed: $error')),
                          );
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      minimumSize: Size(300, 40),
                    ),
                    child: Text('Log In', style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleWardLogin(BuildContext context) async {

    final wardAuthProvider = Provider.of<WardAuthProvider>(context, listen: false);
    final wardUserProvider = Provider.of<WardUserProvider>(context, listen: false);

    await wardAuthProvider.signIn(_emailController.text, _passwordController.text);
    final ward = wardAuthProvider.ward;

    if (ward != null) {
      await wardUserProvider.fetchUser(ward.wardId);
      final db_ward = wardUserProvider.user;

      if (db_ward == null) {
        await wardUserProvider.addUser(ward);
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WardMenuPage()),
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: Wrong Credentials')),
      );
    }
  }

  Future<void> _handleCareGiversLogin(BuildContext context) async {
    final careGiversAuthProvider = Provider.of<CareGiversAuthProvider>(context, listen: false);

    try {
      if (!isCareGiverEmail(_emailController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please provide a valid care giver email.')),
        );
        return;
      }

      await careGiversAuthProvider.signIn(_emailController.text, _passwordController.text);
      final user = careGiversAuthProvider.user;

      if (user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => CareGiversMenuPage()),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: Wrong Credentials')),
        );
      }
    } catch (error) {
      // Handle any errors that occur during the sign-in process
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $error')),
      );
    }
  }



  Future<void> _handleDoctorLogin(BuildContext context) async {
    final doctorsAuthProvider = Provider.of<DoctorsAuthProvider>(context, listen: false);

    try {
      if (!isDoctorEmail(_emailController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please provide a valid doctor email.')),
        );
        return;
      }

      await doctorsAuthProvider.signIn(_emailController.text, _passwordController.text);
      final doctor = doctorsAuthProvider.doctor;

      if (doctor != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DoctorsMenuPage()),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: Wrong Credentials')),
        );
      }
    } catch (error) {
      // Handle any errors that occur during the sign-in process
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $error')),
      );
    }
  }


  Widget buildTextField(TextEditingController controller, String labelText, String hintText, {bool obscureText = false}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }

          if (labelText == 'Email') {
            RegExp emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
            if (!emailRegExp.hasMatch(value)) {
              return 'Please enter a valid email address';
            }
          } else if (labelText == 'Ward ID') {
            RegExp wardIdRegExp = RegExp(r'^[A-Z]{3}\d{6}$');
            if (!wardIdRegExp.hasMatch(value)) {
              return 'Invalid Ward ID format. Example: KMC001050';
            }
          } else if (labelText == 'Password') {
            if (value.contains(' ')) {
              return 'Password cannot contain spaces';
            }

            if (value.length < 6) {
              return 'Password cannot be less than 6 characters';
            }

            if (value.length > 32) {
              return 'Password cannot be longer than 32 characters';
            }
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          suffixIcon: labelText == 'Password'
              ? IconButton(
            icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          )
              : null,
        ),
      ),
    );
  }

  bool isCareGiverEmail(String email) {
    String lowercaseEmail = email.toLowerCase();
    return lowercaseEmail.contains('care');
  }

  bool isDoctorEmail(String email) {
    String lowercaseEmail = email.toLowerCase();
    return lowercaseEmail.contains('care');
  }
}
