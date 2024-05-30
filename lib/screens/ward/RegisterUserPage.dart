// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../user/signup_controller.dart';

class RegisterUserPage extends StatefulWidget {
  const RegisterUserPage({super.key});

  @override
  State<RegisterUserPage> createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  final SignUpController _controller = SignUpController();
  bool obscureText = true;

  List<String> states = [
    'West Bengal',
  ];
  Map<String, List<String>> districtsByState = {
    'West Bengal': ['Kolkata'],
  };
  Map<String, List<String>> wardsByDistrict = {
    'Kolkata': ['Ward 1', 'Ward 2', 'Ward 3'],
  };

  List<String> genders = ['Male', 'Female', 'Other'];

  String? selectedState;
  String? selectedDistrict;
  String? selectedGender;

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
            "Registration",
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
          buildGenderDropdown("Select Your Gender"),
          SizedBox(height: 12),
          buildStateDropdown("Select Your State"),
          SizedBox(height: 12),
          buildDistrictDropdown("Select Your District"),
          SizedBox(height: 12),
          buildWardDropdown("Select Your Ward No"),
          SizedBox(height: 12),
          buildTextField("Enter Your Pin Code", _controller.pin_code, TextInputType.number),
          SizedBox(height: 12),
          buildTextField("Enter Your Aadhaar Number", _controller.aadhaar_number, TextInputType.number),
          SizedBox(height: 12),
          buildPasswordField("Enter Your New Password", _controller.new_pass),
          SizedBox(height: 12),
          buildPasswordField("Confirm Your Password", _controller.confirm_pass),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              if (_controller.formKey.currentState!.validate()) {
                _controller.validateAndSubmit(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              minimumSize: Size(300, 40),
            ),
            child: const Text('Submit',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String hintText, TextEditingController? mycontroller, [TextInputType keyboardType = TextInputType.text]) {
    String prefixText = hintText == "Enter Your Phone Number" ? '+91  ' : '';
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: TextFormField(
        controller: mycontroller,
        keyboardType: keyboardType,
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
        obscureText: obscureText,
        controller: pass_controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a password.';
          }
          if (value.length < 8) {
            return 'Password must be at least 8 characters long.';
          }
          if (!RegExp(r'[A-Z]').hasMatch(value)) {
            return 'Password must contain at least one uppercase letter';
          }
          if (!RegExp(r'[a-z]').hasMatch(value)) {
            return 'Password must contain at least one lowercase letter';
          }
          if (!RegExp(r'[0-9]').hasMatch(value)) {
            return 'Password must contain at least one digit';
          }
          if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
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
          suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget buildGenderDropdown(String hintText) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: DropdownButtonFormField<String>(
        value: selectedGender,
        onChanged: (String? newValue) {
          setState(() {
            selectedGender = newValue;
            _controller.gender.text = newValue ?? ''; // Update controller's gender text
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'You must choose one option';
          }
          return null;
        },
        items: genders.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          labelText: hintText,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
          hintText: hintText,
          fillColor: Colors.white70,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        ),
        isExpanded: false,
      ),
    );
  }

  Widget buildStateDropdown(String hintText) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: DropdownButtonFormField<String>(
        value: selectedState,
        onChanged: (String? newValue) {
          setState(() {
            selectedState = newValue;
            selectedDistrict = null; // Reset district selection when state changes
            _controller.state.text = newValue ?? ''; // Update controller's state text
            _controller.district.text = ''; // Clear district text when state changes
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'You must choose one option';
          }
          return null;
        },
        items: states.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          labelText: hintText,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
          hintText: hintText,
          fillColor: Colors.white70,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        ),
        isExpanded: false,
      ),
    );
  }

  Widget buildDistrictDropdown(String hintText) {
    if (selectedState == null) {
      return Container();
    }
    List<String>? districts = districtsByState[selectedState!];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: DropdownButtonFormField<String>(
        value: selectedDistrict,
        onChanged: (String? newValue) {
          setState(() {
            selectedDistrict = newValue;
            _controller.district.text = newValue ?? ''; // Update controller's district text
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'You must choose one option';
          }
          return null;
        },
        items: districts!.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          labelText: hintText,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
          hintText: hintText,
          fillColor: Colors.white70,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        ),
        isExpanded: false,
      ),
    );
  }

  Widget buildWardDropdown(String hintText) {
    if (selectedDistrict == null) {
      // If no district is selected, show an empty dropdown
      return Container();
    }
    List<String>? wards = wardsByDistrict[selectedDistrict!];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: DropdownButtonFormField<String>(
        value: _controller.ward_no.text.isNotEmpty ? _controller.ward_no.text : null, // Set the initial value to the controller's value if it's not empty
        onChanged: (String? newValue) {
          setState(() {
            _controller.ward_no.text = newValue ?? ''; // Update the controller's value
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'You must choose one option';
          }
          return null;
        },
        items: wards!.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          labelText: hintText,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
          hintText: hintText,
          fillColor: Colors.white70,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        ),
        isExpanded: true,
      ),
    );
  }
}
