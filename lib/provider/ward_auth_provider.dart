// providers/auth_provider.dart
import 'package:final_year_project/models/ward_model.dart';
import 'package:flutter/material.dart';
import '../services/ward_auth_services.dart';

class WardAuthProvider with ChangeNotifier {
  final WardAuthService _authService = WardAuthService();
  WardModel? _ward;

  WardModel? get ward => _ward;

  Future<void> signIn(String email, String password) async {
    _ward = await _authService.signIn(email, password);
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _ward = null;
    notifyListeners();
  }
}
