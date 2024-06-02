import 'package:cloud_firestore/cloud_firestore.dart';

class WardModel {

  String wardId;
  String wardEmail;
  String wardAddress;
  String wardPassword;
  String wardNumber;

  WardModel({
    required this.wardId,
    required this.wardEmail,
    required this.wardAddress,
    required this.wardPassword,
    required this.wardNumber
  });



  static WardModel empty() => WardModel(
    wardId : '',
    wardEmail : '',
    wardAddress : '',
    wardPassword : '',
    wardNumber: ''
  );

  // Convert model to JSON structure for storing data in Firestore
  Map<String, dynamic> toJson() {
    return {
      'wardId' : wardId,
      'wardEmail' : wardEmail,
      'wardAddress' : wardAddress,
      'wardPassword' : wardPassword,
      'wardNumber' : wardNumber
    };
  }

  factory WardModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return WardModel(
        wardId: document.id,
        wardEmail: data['wardEmail'] ?? '',
        wardAddress: data['wardAddress'] ?? '',
        wardPassword: data['wardPassword'] ?? '',
        wardNumber: data['wardNumber'] ?? ''
      );
    } else {
      return WardModel.empty();
    }
  }
}
