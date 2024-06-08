import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  String userId;
  String name;
  String phoneNumber;
  String password;
  String dob;
  String gender;
  String aadhaarNumber;
  String state;
  String district;
  String ward;
  String? profilePictureURL;
  String dateRegistered; // Add dateRegistered field

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
    required this.dateRegistered, // Initialize dateRegistered
    this.profilePictureURL,
  });

  static MyUser empty() => MyUser(
    userId: "",
    name: "ram",
    phoneNumber: "1234567890",
    password: "pass@",
    dob: "12/12/12",
    gender: "male",
    aadhaarNumber: "123456789012",
    state: "bihar",
    district: "alipurduar",
    ward: "007",
    dateRegistered: "", // Initialize dateRegistered
  );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'password': password,
      'dob': dob,
      'gender': gender,
      'aadhaarNumber': aadhaarNumber,
      'state': state,
      'district': district,
      'ward': ward,
      'dateRegistered': dateRegistered, // Include dateRegistered in the map
      'profilePictureURL': profilePictureURL,
    };
  }

  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
      userId: json['userId'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      dob: json['dob'] ?? '',
      ward: json['ward'],
      district: json['district'],
      state: json['state'],
      aadhaarNumber: json['aadhaarNumber'],
      profilePictureURL: json['profilePictureURL'],
      password: json['password'] ?? '',
      dateRegistered: json['dateRegistered'], // Assign dateRegistered from JSON
    );
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
        aadhaarNumber: data['aadhaarNumber'] ?? '',
        state: data['state'] ?? '',
        district: data['district'] ?? '',
        ward: data['ward'] ?? '',
        profilePictureURL: data['profilePictureURL'], // Initialize profileImageUrl
        dateRegistered: data['dateRegistered'], // Assign dateRegistered from Firestore
      );
    } else {
      return MyUser.empty();
    }
  }
}
