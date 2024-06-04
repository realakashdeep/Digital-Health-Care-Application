import 'package:cloud_firestore/cloud_firestore.dart';

class CareGiver {
  final String id;
  final String name;
  final String email;
  final String wardNumber;
  final String password;

  CareGiver({
    required this.id,
    required this.name,
    required this.email,
    required this.wardNumber,
    required this.password,
  });

  factory CareGiver.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data() ?? {};
    return CareGiver(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      wardNumber: data['wardNumber'] ?? '',
      password: data['password'] ?? '', // Retrieve password from Firestore
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'wardNumber': wardNumber,
      'password': password, // Include password in map
    };
  }
}
