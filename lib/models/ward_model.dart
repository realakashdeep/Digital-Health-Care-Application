import 'package:cloud_firestore/cloud_firestore.dart';

class WardModel {

  String wardId;
  String wardEmail;
  String wardAddress;
  String wardPassword;

  WardModel({
    required this.wardId,
    required this.wardEmail,
    required this.wardAddress,
    required this.wardPassword
  });



  static WardModel empty() => WardModel(
    wardId : '',
    wardEmail : '',
    wardAddress : '',
    wardPassword : '',
  );

  // Convert model to JSON structure for storing data in Firestore
  Map<String, dynamic> toJson() {
    return {
      'wardId' : wardId,
      'wardEmail' : wardEmail,
      'wardAddress' : wardAddress,
      'wardPassword' : wardPassword,
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
      );
    } else {
      return WardModel.empty();
    }
  }
}
