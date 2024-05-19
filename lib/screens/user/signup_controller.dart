import 'package:flutter/material.dart';
import 'package:final_year_project/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:final_year_project/provider/auth_provider.dart';
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

  void validateAndSubmit(BuildContext context) {
    // if (formKey.currentState!.validate()) {
      String hashedPassword = hashPassword(new_pass.text);
      sendUserDetails(context, hashedPassword);
    // }
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
      state: state.text.toString(), // Include state field
      district: district.text.toString(), // Include district field
      ward: ward_no.text.toString(), // Include ward field
      aadhaarNumber: aadhaar_number.text.toString(),
    );
    authProvider.signInWithPhone(context, phone_number.text.toString(), user: user);
  }


  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}
