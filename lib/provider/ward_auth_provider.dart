
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/models/ward_model.dart';
import 'package:flutter/material.dart';
import '../services/ward_auth_services.dart';

class WardAuthProvider with ChangeNotifier {
  final WardAuthService _authService = WardAuthService();
  WardModel? _ward;
  WardModel? get ward => _ward;


  // extracts ward number from ward email
  String? extractWardNumber(String email) {
    final regex = RegExp(r'^ward(\d+)@mail\.com$');
    final match = regex.firstMatch(email);

    if (match != null) {
      return match.group(1);
    } else {
      return "-1";
    }
  }

  Future<void> signIn(String email, String password) async {
    int wardNumber = int.parse(extractWardNumber(email).toString());
    if (wardNumber == -1) {
      return;
    }

    // Perform authentication
    WardModel? signInResult = await _authService.signIn(email, password, wardNumber.toString());

    if (signInResult != null) {
      print("signed in as Ward");
      _ward = await fetchWardInfo(email);
    }
    else {
    }
    notifyListeners();
  }

  Future<WardModel?> fetchWardInfo(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('Wards')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> snapshot = querySnapshot.docs.first;

        return WardModel.fromSnapshot(snapshot);
      } else {
        print("ward is null");
        return null;
      }
    } catch (e) {
      print("Error fetching ward information: $e");
      return null;
    }
  }



  Future<void> signOut() async {
    await _authService.signOut();
    _ward = null;
    notifyListeners();
  }
}
