import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserService {
   FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   Future<String?> getCurrentUserId() async {
     return _auth.currentUser?.uid;
   }

   Future<MyUser?> getUserByAadhaar(String aadhaarNumber) async {
     try {
       final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
           .collection('Users').where('aadhaarNumber', isEqualTo: aadhaarNumber).get();

       if (snapshot.docs.isNotEmpty) {
         final userDoc = snapshot.docs.first;
         return MyUser.fromSnapshot(userDoc);
       } else {
         return null; // No user found with the given Aadhaar number
       }
     } catch (e) {
       print('Error retrieving user by Aadhaar number: $e');
       return null;
     }
   }

  // Create a new user in Firebase Auth and Firestore
  Future<void> createUser(MyUser user) async {
    try {
      // Save user details to Firestore
      await _firestore.collection('Users').doc(user.userId).set(user.toJson());
      await _firestore.collection('BasicUser').doc(user.userId).set(user.toJson());
    } catch (e) {
      throw Exception('Error creating user: $e');
    }
  }

  // Retrieve a user from Firestore using the userId
  Future<MyUser?> getUser(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await _firestore.collection('Users').doc(userId).get();
      if (doc.exists) {
        return MyUser.fromSnapshot(doc);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  // Update user details in Firestore
  Future<void> updateUser(MyUser user) async {
    try {
      await _firestore.collection('Users').doc(user.userId).update(user.toJson());
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  // Delete a user from Firebase Auth and Firestore
  Future<void> deleteUser(String userId) async {
    try {
      // Delete user from Firebase Auth
      User? user = _auth.currentUser;
      if (user != null && user.uid == userId) {
        await user.delete();
      }
      // Delete user document from Firestore
      await _firestore.collection('Users').doc(userId).delete();
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }
   Future<void> updateUserProfilePicture(String userId, String profilePictureURL) async {
     try {
       await _firestore.collection('Users').doc(userId).update({'profilePictureURL': profilePictureURL});
     } catch (e) {
       throw Exception('Error updating user profile picture URL: $e');
     }
   }



  // Sign out the current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Error signing out: $e');
    }
  }
}
