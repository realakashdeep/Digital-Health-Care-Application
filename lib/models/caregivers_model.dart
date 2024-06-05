import 'package:cloud_firestore/cloud_firestore.dart';

class CareGiver {
  final String id;
  final String name;
  final String email;
  final String wardNumber;
  final String password;
  final bool isCaregiver;

  CareGiver({
    required this.id,
    required this.name,
    required this.email,
    required this.wardNumber,
    required this.password,
    required this.isCaregiver,
  });

  factory CareGiver.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data() ?? {};
    return CareGiver(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      wardNumber: data['wardNumber'] ?? '',
      password: data['password'] ?? '',
      isCaregiver: data['isCaregiver'] ?? false,
    );
  }
  factory CareGiver.fromMap(Map<String, dynamic> map) {
    return CareGiver(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      wardNumber: map['wardNumber'] ?? '',
      password: map['password'] ?? '',
      isCaregiver: map['isCaregiver'] ?? false, // Extract the new field from the map
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'wardNumber': wardNumber,
      'password': password,
      'isCaregiver': isCaregiver,
    };
  }
}
