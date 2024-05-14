import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  String userId;
  String name;
  String phoneNumber;
  String password;
  String dob;
  String gender;
  // String address;
  String aadhaarNumber;
  String state;
  String district;
  String ward;

  MyUser({
    required this.userId,
    required this.name,
    required this.phoneNumber,
    required this.password,
    required this.dob,
    required this.gender,
    required this.aadhaarNumber,
    required this.state,
    required this.district,
    required this.ward,
  });

  static MyUser empty() => MyUser(
    userId: "",
    name: "",
    phoneNumber: "",
    password: "",
    dob: "",
    gender: "",
    // address: "",
    aadhaarNumber: "",
    state: "",
    district: "",
    ward: "",
  );

  // Convert model to JSON structure for storing data in Firestore
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'password': password,
      'dob': dob,
      'gender': gender,
      // 'address': address,
      'aadhaarNumber': aadhaarNumber,
      'state': state,
      'district': district,
      'ward': ward,
    };
  }

  factory MyUser.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return MyUser(
        userId: document.id,
        name: data['name'] ?? '',
        phoneNumber: data['phoneNumber'] ?? '',
        password: data['password'] ?? '',
        dob: data['dob'] ?? '',
        gender: data['gender'] ?? '',
        // address: data['address'] ?? '',
        aadhaarNumber: data['aadhaarNumber'] ?? '',
        state: data['state'] ?? '',
        district: data['district'] ?? '',
        ward: data['ward'] ?? '',
      );
    } else {
      return MyUser.empty();
    }
  }
}
