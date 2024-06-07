import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser{
  String name;
  String dateRegistered;
  String ward;

  MyUser({
    required this.name,
    required this.dateRegistered,
    required this.ward
  });

  static MyUser empty() => MyUser(
    name: "",
    ward: "",
    dateRegistered: ""
  );

  Map<String, dynamic> toJson() {
    return {
      'name' : name,
      'ward' : ward,
      'dateRegistered' : dateRegistered
    };
  }

  factory MyUser.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return MyUser(
        name: data['name'] ?? '',
        ward: data['ward'] ?? '',
        dateRegistered: data['dateRegistered'] ?? ''
      );
    } else {
      return MyUser.empty();
    }
  }


}