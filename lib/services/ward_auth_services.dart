import 'package:final_year_project/models/ward_model.dart';
import 'package:firebase_auth/firebase_auth.dart';




class WardAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<WardModel?> signIn(String email, String password, String wardNumber) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return WardModel(wardId: user!.uid, wardEmail: user.email!, wardPassword: password, wardAddress: '', wardNumber: wardNumber);
    } catch (e) {
      throw Exception('Sign-in failed: $e');
    }
  }


  Future<void> signOut() async {
    await _auth.signOut();
  }
}
