import 'package:flutter/material.dart';
import 'signup_controller.dart';

class UserSignUp extends StatefulWidget {
  const UserSignUp({Key? key}) : super(key: key);

  @override
  State<UserSignUp> createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
  final SignUpController _controller = SignUpController();

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
          _buildUI(),
        ],
      ),
    );
  }

  Widget _buildUI() {
    return SingleChildScrollView(
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
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _controller.formKey,
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
          buildTextField("Enter Your Name", _controller.name),
          SizedBox(height: 12),
          buildTextField("Enter Your Phone Number", _controller.phone_number),
          SizedBox(height: 12),
          buildTextField("Enter Your Gender", _controller.gender),
          SizedBox(height: 12),
          buildTextField("Enter Your State", _controller.state),
          SizedBox(height: 12),
          buildTextField("Enter Your District", _controller.district),
          SizedBox(height: 12),
          buildTextField("Enter Your Ward No",_controller.ward_no),
          SizedBox(height: 12),
          buildTextField("Enter Your Pin Code", _controller.pin_code),
          SizedBox(height: 12),
          buildTextField("Enter Your Aadhaar Number",_controller.aadhaar_number),
          SizedBox(height: 12),
          buildPasswordField("Enter Your New Password",_controller.new_pass),
          SizedBox(height: 12),
          buildPasswordField("Confirm Your Password",_controller.confirm_pass),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              _controller.validateAndSubmit(context);
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String hintText, TextEditingController? mycontroller) {
    String prefixText = hintText == "Enter Your Phone Number" ? '+91  ' : '';
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: TextFormField(
        controller: mycontroller,
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
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
          hintText: hintText,
          prefixText: prefixText,
          prefixStyle: TextStyle(color: Colors.grey, fontSize: 17),
          fillColor: Colors.white70,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        ),
      ),
    );
  }

  Widget buildPasswordField(String hintText, TextEditingController? pass_controller) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: TextFormField(
        obscureText: true,
        controller: pass_controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a password.';
          }
          if (value.length < 8) {
            return 'Password must be at least 8 characters long.';
          }
          if( RegExp(r'[A-Z]').hasMatch(value)) {
            return 'Password must contain at least one uppercase letter';
          }
          if(RegExp(r'[a-z]').hasMatch(value)){
            return 'Password must contain at least one lowercase letter';
          }
          if(RegExp(r'[0-9]').hasMatch(value)){
            return 'Password must contain at least one digit';
          }
          if(RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)){
            return 'Password must contain at least one special character.';
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

}
