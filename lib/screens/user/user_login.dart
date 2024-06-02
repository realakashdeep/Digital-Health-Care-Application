import 'package:final_year_project/constants/text_strings.dart';
import 'package:final_year_project/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserLogin extends StatefulWidget {
  UserLogin({Key? key}) : super(key: key);

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  ImageProvider logo = AssetImage("assets/login_user_image.jpg");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false; // Add a loading state variable

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
                _isLoading // Show CircularProgressIndicator when loading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true; // Set loading state to true
                      });

                      bool isRegistered = await Provider.of<AuthProvider>(context, listen: false)
                          .checkIfNumberRegistered(phoneNumberController.text.toString());
                      if (isRegistered) {
                        await Provider.of<AuthProvider>(context, listen: false).logInWithPhone(
                          context,
                          phoneNumberController.text.toString(),
                          passwordController.text.toString(),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('No user found with this phone number.')),
                        );
                      }

                      setState(() {
                        _isLoading = false; // Reset loading state after the process
                      });
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
                    'Log in',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget userCred(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: phoneNumberController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Enter Phone Number',
              hintText: 'Enter Phone Number',
              hintStyle: TextStyle(color: Colors.grey),
              alignLabelWithHint: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              prefixText: '+91 ', // Add prefix text
              prefixStyle: TextStyle(color: Colors.grey, fontSize: 16), // Style the prefix text
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your phone number";
              }
              if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: passwordController,
            obscureText: _isObscure,
            decoration: InputDecoration(
              labelText: tPassword,
              hintText: 'Enter Password',
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
              alignLabelWithHint: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              suffixIcon: IconButton(
                icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your password";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
