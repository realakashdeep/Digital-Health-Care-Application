import 'package:cloud_firestore/cloud_firestore.dart';

class Camp {
  final String id;
  final String name;
  final String description;
  final String startDate;
  final String address;
  final String headDoctor;
  final String lastDate;
  final String uploadedBy;
  final String uploadedOn;
  final String wardId; 

  Camp({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.address,
    required this.headDoctor,
    required this.lastDate,
    required this.uploadedBy,
    required this.uploadedOn,
    required this.wardId,
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
      uploadedBy: data['uploadedBy'] ?? '',
      uploadedOn: data['uploadedOn'] ?? '',
      wardId: data['wardId'] ?? '', // New field
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
      'uploadedBy': uploadedBy,
      'uploadedOn': uploadedOn,
      'wardId': wardId, // New field
    };
  }
}
