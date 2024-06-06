import 'package:cloud_firestore/cloud_firestore.dart';

class WardModel {

  String wardId;
  String wardEmail;
  String wardAddress;
  String wardPassword;
  String wardNumber;
  String wardImageUrl;
  String wardSubtitle;
  String wardSummary;
  String wardContactNumber;

  WardModel({
    required this.wardId,
    required this.wardEmail,
    required this.wardAddress,
    required this.wardPassword,
    required this.wardNumber,
    required this.wardImageUrl,
    required this.wardSubtitle,
    required this.wardSummary,
    required this.wardContactNumber
  });



  static WardModel empty() => WardModel(
      wardId : '',
      wardEmail : '',
      wardAddress : '',
      wardPassword : '',
      wardNumber: '',
      wardImageUrl: '',
      wardSubtitle: '',
      wardSummary: '',
      wardContactNumber: ''
  );

  // Convert model to JSON structure for storing data in Firestore
  Map<String, dynamic> toJson() {
    return {
      'wardId' : wardId,
      'wardEmail' : wardEmail,
      'wardAddress' : wardAddress,
      'wardPassword' : wardPassword,
      'wardNumber' : wardNumber,
      'wardImageUrl' : wardImageUrl,
      'wardSubtitle' :wardSubtitle,
      'wardSummary' : wardSummary,
      'wardContactNumber' : wardContactNumber
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
        wardNumber: data['wardNumber'] ?? '',
        wardImageUrl: data['wardImageUrl'] ?? '',
          wardSubtitle: data['wardSubtitle'] ?? '',
        wardContactNumber: data['wardContactNumber'] ?? '',
        wardSummary: data['wardSummary'] ?? '',
      );
    } else {
      return WardModel.empty();
    }
  }
}
