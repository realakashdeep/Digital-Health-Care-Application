
import 'package:final_year_project/provider/ward_user_provider.dart';
import 'package:final_year_project/screens/ward/ward_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/ward_auth_provider.dart';

class WardLoginPage extends StatefulWidget {
  @override
  _WardLoginPageState createState() => _WardLoginPageState();
}

class _WardLoginPageState extends State<WardLoginPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _wardIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();


  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final wardAuthProvider = Provider.of<WardAuthProvider>(context);
    final wardUserProvider = Provider.of<WardUserProvider>(context);

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
                    'Ward Login',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 40),
                  buildTextField(_emailController, 'Email', 'Enter Ward Email'),
                  SizedBox(height: 16),
                  buildTextField(_passwordController, 'Password', 'Enter Ward Password', obscureText: true),
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
                          await wardAuthProvider.signIn(
                            _emailController.text,
                            _passwordController.text,
                          );
                          final ward = wardAuthProvider.ward;
                          if (ward != null) {
                            await wardUserProvider.fetchUser(ward.wardId);
                            final db_ward = wardUserProvider.user;
                            if (db_ward == null) {
                              await wardUserProvider.addUser(ward);
                            }
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WardMenuPage(),
                              ),
                                  (route) => false,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Login failed: Wrong Credentials')),
                            );
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
        ),
      ),
    );
  }
}
