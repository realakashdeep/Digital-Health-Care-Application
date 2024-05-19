
import 'package:final_year_project/constants/text_strings.dart';
import 'package:final_year_project/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserLogin extends StatelessWidget {

  ImageProvider logo = AssetImage("assets/login_user_image.jpg");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  UserLogin({Key? key}) : super(key: key);

  final TextEditingController phoneNumberController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.zero,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: logo,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  child: Text(
                    tLogin,
                    style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                userCred(context),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Provider.of<AuthProvider>(context, listen: false).signInWithPhone(context,phoneNumberController.text.toString());
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => UserHome()),
                      // );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: Size(300, 40),
                  ),
                  child: Text(tLogin, style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                // Add a SizedBox to give some space above the button when the keyboard is open
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget userCred(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 45, right: 45),
      child: Column(
        children: [
          SizedBox(
            child: TextFormField(
              controller: phoneNumberController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter User ID/Phone Number';
                }
                if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Enter User ID/Phone Number',
                hintText: 'Enter User ID/Phone Number',
                hintStyle: TextStyle(color: Colors.grey),
                alignLabelWithHint: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            child: TextFormField(
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.contains(' ')) {
                  return 'Password cannot contain spaces';
                }

                if (value.length > 32) {
                  return 'Password cannot be longer than 32 characters';
                }

                if (value.length < 8) {
                  return 'Password cannot be less than 8 characters';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: tPassword,
                hintText: 'Enter Password',
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                alignLabelWithHint: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
