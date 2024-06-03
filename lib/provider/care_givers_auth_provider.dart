import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../services/CareGiversService.dart';

class CareGiversAuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CareGiversService _service = CareGiversService();
  User? _user;

  User? get user => _user;

  Future<void> signIn(String email, String password) async {
    try {
      User? user = await _service.signIn(email, password);
      _user = user;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
