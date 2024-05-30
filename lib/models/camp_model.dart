import 'package:cloud_firestore/cloud_firestore.dart';

class Camp {
  final String id;
  final String name;
  final String description;
  final String startDate; // Change type to String
  final String address;
  final String headDoctor;
  final String lastDate; // Change type to String

  Camp({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.address,
    required this.headDoctor,
    required this.lastDate,
  });

  factory Camp.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Camp(
      id: snapshot.id,
      name: data['campName'] ?? '',
      description: data['description'] ?? '',
      startDate: data['startDate'] ?? '',
      address: data['address'] ?? '',
      headDoctor: data['headDoctor'] ?? '',
      lastDate: data['lastDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'campName': name,
      'description': description,
      'startDate': startDate,
      'address': address,
      'headDoctor': headDoctor,
      'lastDate': lastDate,
    };
  }
}
