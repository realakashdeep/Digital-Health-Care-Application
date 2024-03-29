import 'package:flutter/material.dart';
import 'package:final_year_project/screens/user/user_otp.dart';

class UserSignUp extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? confirmPassword = '';
  int setConfirmPassword = 0;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/signup_user_image.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 180, left: 0, right: 0),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          'Registration',
                          style: TextStyle(
                            fontSize: 40,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 20),
                        buildTextField("Enter Your Name"),
                        SizedBox(height: 12),
                        buildTextField("Enter Your Phone Number"),
                        SizedBox(height: 12),
                        buildTextField("Enter Your Gender"),
                        SizedBox(height: 12),
                        buildTextField("Enter Your State"),
                        SizedBox(height: 12),
                        buildTextField("Enter Your District"),
                        SizedBox(height: 12),
                        buildTextField("Enter Your Ward No"),
                        SizedBox(height: 12),
                        buildTextField("Enter Your Pin Code"),
                        SizedBox(height: 12),
                        buildTextField("Enter Your Aadhaar Number"),
                        SizedBox(height: 12),
                        buildPasswordField("Enter Your New Password", controller: _newPasswordController),
                        SizedBox(height: 12),
                        buildPasswordField("Confirm Your Password", controller: null),
                        SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Proceed to the next page
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Otp()),
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
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String hintText, {TextEditingController? controller}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: TextFormField(
        validator: (value) {

          if (value == null || value.isEmpty) {
            return 'Please $hintText';
          }
          if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value) && hintText == "Enter Your Name") {
            return 'Please enter a valid name';
          }
          if (!RegExp(r'^[0-9]{10}$').hasMatch(value) && hintText == "Enter Your Phone Number") {
            return 'Please enter a valid phone number';
          }
          if (!RegExp(r'^[0-9]{6}$').hasMatch(value) && hintText == "Enter Your Pin Code") {
            return 'Please enter a valid PIN code';
          }
          if (!RegExp(r'^[0-9]{12}$').hasMatch(value) && hintText == "Enter Your Aadhaar Number") {
            return 'Please enter a valid Aadhaar code';
          }
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          labelText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          hintText: hintText,
          fillColor: Colors.white70,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        ),
      ),
    );
  }

  Widget buildPasswordField(String hintText, {required TextEditingController? controller}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: TextFormField(
        obscureText: true,
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please $hintText';
          }

          if (value.contains(' ') && hintText.contains("Password")) {
            return 'Password cannot contain spaces';
          }

          if (value.length > 32 && hintText.contains("Password")) {
            return 'Password cannot be longer than 32 characters';
          }

          if (value.length < 8 && hintText.contains("Password")) {
            return 'Password cannot be less than 8 characters';
          }

          if (hintText == "Confirm Your Password" && value != _newPasswordController.text) {
            return 'Passwords do not match';
          }

          // Compare with the password entered in the "Enter Your New Password" field
          // if (hintText == "Confirm Your Password" && value != _passwordController.text) {
          //   return 'Passwords do not match';
          // }

          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          labelText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          hintText: hintText,
          fillColor: Colors.white70,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        ),
      ),
    );
  }

}
