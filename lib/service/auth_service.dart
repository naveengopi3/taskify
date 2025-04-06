import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskify/screens/auth/login_screen.dart';
import 'package:taskify/screens/home/home_screen.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        await user.updateProfile(displayName: name);
        await user.reload();

        await user.sendEmailVerification();
        await _firestore.collection("users").doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          'isEmailVerified': false,
        });
        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> resendVerificationEmail(User user) async {
    try {
      await user.sendEmailVerification();
    } catch (e) {
      throw Exception("Failed to send verification email.");
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> checkLogedIn(BuildContext context) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await updateEmailVerifiedStatus(user);
      if (user.emailVerified) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please verify your email")),
        );
      }
    } else {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  Future<void> updateEmailVerifiedStatus(User user) async {
    try {
      await user.reload();
      User? updatedUser = _auth.currentUser;
      if (updatedUser != null && updatedUser.emailVerified) {
        DocumentReference userDoc = _firestore
            .collection("users")
            .doc(updatedUser.uid);
        bool docExist = (await userDoc.get()).exists;

        if (docExist) {
          await userDoc.update({"isEmailVerified": true});
        } else {
          await userDoc.set({
            'uid': updatedUser.uid,
            'emai': updatedUser.email,
            'isEmailVerified': true,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
        print('Email verified status updated in Firestore!');
      }
    } catch (e) {
      print('Error updating email verified status: $e');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
