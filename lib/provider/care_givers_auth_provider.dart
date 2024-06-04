import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  String _encryptPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
  Future<bool> _checkPassword(String collection, String password) async {
    final querySnapshot = await _firestore
        .collection(collection)
        .where('password', isEqualTo: password)
        .limit(1)
        .get();

    if(querySnapshot.docs.isNotEmpty)
      print("password matched"+ password);
    else
      print(" password does not matched" + password);

    return querySnapshot.docs.isNotEmpty;
  }
}
