import 'package:cloud_firestore/cloud_firestore.dart';

class Caregiver {
  final String id; // Document ID from Firestore
  final String name;
  final String email;
  final String wardNumber;

  Caregiver({
    required this.id,
    required this.name,
    required this.email,
    required this.wardNumber,
  });

  factory Caregiver.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data() ?? {};
    return Caregiver(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      wardNumber: data['wardNumber'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'wardNumber': wardNumber,
    };
  }
}
