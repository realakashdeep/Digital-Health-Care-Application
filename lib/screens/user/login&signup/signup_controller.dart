import 'package:flutter/material.dart';
import 'package:final_year_project/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:final_year_project/provider/user/auth_provider.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class SignUpController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController phone_number = TextEditingController();
  final TextEditingController gender = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController district = TextEditingController();
  final TextEditingController ward_no = TextEditingController();
  final TextEditingController pin_code = TextEditingController();
  final TextEditingController aadhaar_number = TextEditingController();
  final TextEditingController new_pass = TextEditingController();
  final TextEditingController confirm_pass = TextEditingController();
  final TextEditingController dob = TextEditingController();

  void validateAndSubmit(BuildContext context) async {
    // if (formKey.currentState!.validate()) {
      bool isRegistered = await checkIfNumberRegistered(context);
      if (isRegistered) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Phone number is already registered.'),
            backgroundColor: Colors.blue,
          ),
        );
      } else {
        String hashedPassword = hashPassword(new_pass.text);
        sendUserDetails(context, hashedPassword);
      }
    //}
  }

  Future<bool> checkIfNumberRegistered(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return await authProvider.checkIfNumberRegistered(phone_number.text.toString());
  }

  void sendUserDetails(BuildContext context, String hashedPassword) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    MyUser user = MyUser(
      userId: '',
      name: name.text.toString(),
      phoneNumber: phone_number.text.toString(),
      password: hashedPassword,
      dob: dob.text.toString(),
      gender: gender.text.toString(),
      state: state.text.toString(),
      district: district.text.toString(),
      ward: ward_no.text.toString(),
      aadhaarNumber: aadhaar_number.text.toString(),
    );
    authProvider.registerUser(context, user);
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}
