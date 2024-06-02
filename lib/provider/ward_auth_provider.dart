
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
    if(wardNumber == -1){
      return;
    }
    _ward = await _authService.signIn(email, password,wardNumber.toString());
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _ward = null;
    notifyListeners();
  }
}
