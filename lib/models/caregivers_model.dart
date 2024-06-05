import 'package:cloud_firestore/cloud_firestore.dart';

class CareGiver {
  final String id;
  final String name;
  final String email;
  final String wardNumber;
  final String password;
  final bool isCaregiver; // New field to indicate caregiver status

  CareGiver({
    required this.id,
    required this.name,
    required this.email,
    required this.wardNumber,
    required this.password,
    required this.isCaregiver, // Include isCaregiver field in the constructor
  });

  factory CareGiver.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data() ?? {};
    return CareGiver(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      wardNumber: data['wardNumber'] ?? '',
      password: data['password'] ?? '',
      isCaregiver: data['isCaregiver'] ?? false, // Retrieve isCaregiver from Firestore
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'wardNumber': wardNumber,
      'password': password,
      'isCaregiver': isCaregiver, // Include isCaregiver in map
    };
  }
}
