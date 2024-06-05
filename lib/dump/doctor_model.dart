import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorModel {

  String doctorId;
  String doctorName;
  String wardNumber;
  String contactNumber;

  DoctorModel({
    required this.doctorId,
    required this.doctorName,
    required this.wardNumber,
    required this.contactNumber
  });



  static DoctorModel empty() => DoctorModel(
      doctorId : '',
      doctorName : '',
      wardNumber: '',
      contactNumber: ''
  );

  // Convert model to JSON structure for storing data in Firestore
  Map<String, dynamic> toJson() {
    return {
      'doctorId' : doctorId,
      'doctorName' : doctorName,
      'wardNumber' : wardNumber,
      'contactNumber' : contactNumber
    };
  }

  factory DoctorModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return DoctorModel(
          doctorId: document.id,
          doctorName: data['doctorName'] ?? '',
          wardNumber: data['wardNumber'] ?? '',
          contactNumber: data['contactNumber'] ?? ''
      );
    } else {
      return DoctorModel.empty();
    }
  }
}
