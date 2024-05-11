import 'package:final_year_project/screens/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_year_project/provider/auth_provider.dart' as MyAppAuthProvider;

class SignUpController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final phone_number = TextEditingController();
  final gender = TextEditingController();
  final state = TextEditingController();
  final district = TextEditingController();
  final ward_no = TextEditingController();
  final pin_code = TextEditingController();
  final aadhaar_number = TextEditingController();
  final new_pass = TextEditingController();
  final confirm_pass = TextEditingController();
  final dob = TextEditingController();

  void validateAndSubmit(BuildContext context) {
    // if (formKey.currentState!.validate()) {
      sendPhoneNumber(context);
    // }
  }

  void sendPhoneNumber(BuildContext context) {
    final ap = Provider.of<MyAppAuthProvider.AuthProvider>(context, listen: false);
    MyUser user = MyUser(
        userId: '',
        name: name.text.toString(),
        phoneNumber: phone_number.text.toString(),
        password: new_pass.text.toString(),
        dob: dob.text.toString(),
        gender: gender.text.toString(),
        address: district.text.toString(),
        aadhaarNumber: aadhaar_number.text.toString());
    ap.signInWithPhone(context, phone_number.text.toString(),user);
  }

}
