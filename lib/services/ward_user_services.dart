import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/models/ward_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WardUserServices {
   FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createward(WardModel ward) async {
    try {
      await _firestore.collection('Wards').doc(ward.wardId).set(ward.toJson());
    } catch (e) {
      throw Exception('Error creating ward: $e');
    }
  }

  Future<WardModel?> getward(String wardId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await _firestore.collection('Wards').doc(wardId).get();
      if (doc.exists) {
        return WardModel.fromSnapshot(doc);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error fetching ward: $e');
    }
  }

  Future<void> updateward(WardModel ward) async {
    try {
      await _firestore.collection('Wards').doc(ward.wardId).update(ward.toJson());
    } catch (e) {
      throw Exception('Error updating ward: $e');
    }
  }

  Future<void> deleteward(String wardId) async {
    try {
      // Delete ward from Firebase Auth
      User? ward = _auth.currentUser;
      if (ward != null && ward.uid == wardId) {
        await ward.delete();
      }
      await _firestore.collection('Wards').doc(wardId).delete();
    } catch (e) {
      throw Exception('Error deleting ward: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Error signing out: $e');
    }
  }

   Future<String?> getCurrentUserId() async {
     try {
       User? user = _auth.currentUser;
       return user?.uid;
     } catch (e) {
       throw Exception('Error fetching user ID: $e');
     }
   }

}
