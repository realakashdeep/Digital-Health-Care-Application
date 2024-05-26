
import 'package:final_year_project/models/ward_model.dart';
import 'package:firebase_auth/firebase_auth.dart';


class WardAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<WardModel?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return WardModel(wardId: user!.uid, wardEmail: user.email!,wardPassword: password, wardAddress: '');
    } catch (e) {
      // Handle error
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
