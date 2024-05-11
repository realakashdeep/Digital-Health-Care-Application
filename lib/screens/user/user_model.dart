import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser{
  String userId;
  String name;
  String phoneNumber;
  String password;
  String dob;
  String gender;
  String address;
  String aadhaarNumber;

  MyUser({
    required this.userId,
    required this.name,
    required this.phoneNumber,
    required this.password,
    required this.dob,
    required this.gender,
    required this.address,
    required this.aadhaarNumber
  });

  static MyUser empty() => MyUser(
      userId: "",
      name: "",
      phoneNumber: "",
      password: "",
      dob: "",
      gender: "",
      address: "",
      aadhaarNumber: "");


  //Convert model to Json structure to storing data in firebase
  Map<String ,dynamic> toJson(){
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'password': password,
      'dob': dob,
      'gender': gender,
      'address': address,
      'aadhaarNumber': aadhaarNumber
    };
  }

  factory MyUser.fromSnapshot(DocumentSnapshot<Map<String,dynamic>>document){
    if(document.data() != null){
      final data = document.data()!;
      return MyUser(
          userId: document.id
          ,name: data['name'] ?? ''
          , phoneNumber: data['phoneNumber'] ?? ''
          , password: data['password'] ?? ''
          , dob: data['dob'] ?? ''
          , gender: data['gender'] ?? ''
          , address: data['address'] ?? ''
          , aadhaarNumber: data['aadhaarNumber'] ?? ''
      );
    }
    else{
      return MyUser.empty();
    }

  }
}
