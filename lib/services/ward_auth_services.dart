import 'package:final_year_project/models/ward_model.dart';
import 'package:firebase_auth/firebase_auth.dart';




class WardAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password, String wardNumber) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if(user != null){
        return user;
      }
    } catch (e) {
      throw Exception('Sign-in failed: $e');
    }
    return null;
  }


  Future<void> signOut() async {
    await _auth.signOut();
  }
}
