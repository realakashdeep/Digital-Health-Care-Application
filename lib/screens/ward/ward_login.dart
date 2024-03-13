import 'package:final_year_project/screens/ward/ward_menu.dart';
import 'package:flutter/material.dart';

class WardLoginPage extends StatefulWidget {
  @override
  _WardLoginPageState createState() => _WardLoginPageState();
}

class _WardLoginPageState extends State<WardLoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _wardIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Allow the widget to resize when the keyboard appears
      appBar: AppBar(
        title: Text('Digital HealthCare Facilities'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                  SizedBox(height: 80),
                  buildTextField(_wardIdController, 'Ward ID', 'Enter Ward ID'),
                  SizedBox(height: 16),
                  buildTextField(_passwordController, 'Password', 'Enter Ward Password', obscureText: true),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Perform login logic here
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WardMenuPage()),
                        );
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
      margin: EdgeInsets.only(left: 45, right: 45),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          RegExp wardIdRegExp = RegExp(r'^[A-Z]{3}\d{6}$');
          if (!wardIdRegExp.hasMatch(value) && controller == _wardIdController) {
            return 'Invalid Ward ID format';
          }
          else if(controller == _passwordController){
            if (value.contains(' ')) {
              return 'Password cannot contain spaces';
            }

            if (value.length > 32) {
              return 'Password cannot be longer than 32 characters';
            }

            if (value.length < 8) {
              return 'Password cannot be less than 8 characters';
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
