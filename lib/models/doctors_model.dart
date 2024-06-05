import 'dart:convert';

class Doctor {
  final String name;
  final String email;
  final String wardNumber;
  final String password;
  final bool isDoctor; // New field

  Doctor({
    required this.name,
    required this.email,
    required this.wardNumber,
    required this.password,
    required this.isDoctor, // Include the new field in the constructor
  });

  // Convert a Doctor object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'wardNumber': wardNumber,
      'password': password,
      'isDoctor': isDoctor, // Include the new field in the map
    };
  }

  // Extract a Doctor object from a Map object
  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      wardNumber: map['wardNumber'] ?? '',
      password: map['password'] ?? '',
      isDoctor: map['isDoctor'] ?? false, // Extract the new field from the map
    );
  }

  // Convert a Doctor object into a JSON object
  String toJson() => json.encode(toMap());

  // Extract a Doctor object from a JSON object
  factory Doctor.fromJson(String source) => Doctor.fromMap(json.decode(source));
}
