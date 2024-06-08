import 'dart:convert';

class Doctor {
  final String id;
  final String name;
  final String email;
  final String wardNumber;
  final String password;
  final String aboutDoctor;
  final String doctorContactNumber;
  final String doctorImageUrl;

  Doctor({
    required this.id,
    required this.name,
    required this.email,
    required this.wardNumber,
    required this.password,
    required this.aboutDoctor,
    required this.doctorContactNumber,
    required this.doctorImageUrl,
  });

  // Convert a Doctor object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'wardNumber': wardNumber,
      'password': password,
      'aboutDoctor' : aboutDoctor,
      'doctorContactNumber' : doctorContactNumber,
      'doctorImageUrl' : doctorImageUrl
    };
  }

  // Extract a Doctor object from a Map object
  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      wardNumber: map['wardNumber'] ?? '',
      password: map['password'] ?? '',
      aboutDoctor: map['aboutDoctor'] ?? '',
      doctorContactNumber: map['doctorContactNumber'] ?? '',
      doctorImageUrl: map['doctorImageUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Doctor.fromJson(String source) => Doctor.fromMap(json.decode(source));
}
