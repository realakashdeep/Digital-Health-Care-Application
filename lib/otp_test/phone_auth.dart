import 'package:final_year_project/otp_test/otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});

  @override
  State<PhoneAuth> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<PhoneAuth> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone Auth"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Enter Your number",
            suffixIcon: Icon(Icons.phone),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24))
          ),
        ),
        ),
        SizedBox(height: 30),
        ElevatedButton( 
          onPressed: ()async{
            await FirebaseAuth.instance.verifyPhoneNumber(
              verificationCompleted: (PhoneAuthCredential credential){ }, 
              verificationFailed: (FirebaseAuthException exception){ }, 
              codeSent: (String verificationId ,int? resendToken){

                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyOtp(verificationid:verificationId)));

              },  
              codeAutoRetrievalTimeout: (String verificationId){},
              phoneNumber: "+91" + controller.text.toString()
            );
          }, 
          child: Text("Verify Phone Number"))
      ],),
    );
  }
}