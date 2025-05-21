import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String userId;
  String username;
  String email;
  String contactNumber;
  final bool isAdmin;
  final dynamic createdOn;

  UserModel({
    required this.userId,
    required this.username,
    required this.email,
    required this.contactNumber,
    required this.isAdmin,
    required this.createdOn,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId, 
      'username': username,
      'email': email,
      'contactNumber': contactNumber,
      'isAdmin': isAdmin,
      'createdOn': createdOn,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] ?? '', 
      username: map['username'] ?? 'Guest',
      email: map['email'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
      createdOn: map['createdOn'] ?? Timestamp.now(),
    );
  }

  static Future<UserCredential> createUserWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  static Future<UserCredential> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveUserToFirestore() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        ...toMap(),
        'createdOn': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  static Future<UserModel?> getUserFromFirestore(String userId) async {
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserProfileInFirestore({
    String? newUsername,
    String? newContactNumber,
  }) async {
    try {
      Map<String, dynamic> updatedData = {};

      if (newUsername != null && newUsername != username) {
        updatedData['username'] = newUsername;
      }

      if (newContactNumber != null && newContactNumber != contactNumber) {
        updatedData['contactNumber'] = newContactNumber;
      }

      if (updatedData.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update(updatedData);
      }
    } catch (e) {
      rethrow;
    }
  }
}
