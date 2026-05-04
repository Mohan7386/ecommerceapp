import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool isLoading = false;
  bool isPasswordLoading = false;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  User? user;

  AuthProvider() {
    _auth.authStateChanges().listen((User? currentUser) {
      user = currentUser;
      _isInitialized = true;
      notifyListeners();
    });
  }

  bool get isLoggedIn => user != null;

  Future<String?> signUp(
      String name,
      String phone,
      String email,
      String password,
      ) async {
    try {
      isLoading = true;
      notifyListeners();

      final userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = userCredential.user!;

      await user.sendEmailVerification();

      await user.updateDisplayName(name);

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .set({
        "uid": user.uid,
        "name": name,
        "phone": phone,
        "email": email,
        "createdAt": FieldValue.serverTimestamp(),
      });

      return null;

    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e);

    } catch (e) {
      print(" FULL ERROR: $e");
      return "Something went wrong";

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  //  LOGIN
  Future<String?> login(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> forgotPassword(String email) async {
    try {
      isLoading = true;
      notifyListeners();

      await _auth.sendPasswordResetEmail(
        email: email.trim(),
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e);
    } catch (e) {
      print(" Forgot Password Error: $e");
      return "Something went wrong";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  //  GOOGLE LOGIN

  Future<String?> signInWithGoogle() async {
    try {
      isLoading = true;
      notifyListeners();

      //  Step 1: Pick account
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return "User cancelled login";
      }

      //  Step 2: Get auth tokens
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      //  Step 3: Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth .idToken,
      );

      //  Step 4: Sign in Firebase
      final userCredential  = await _auth.signInWithCredential(credential);

      final user = userCredential.user;

      if (user == null) {
        return "Google sign-in failed";
      }

      //  Step 5: Store user (first time only)
      final doc = FirebaseFirestore.instance.collection("users").doc(user.uid);

      final snapshot = await doc.get();

      if (!snapshot.exists) {
        await doc.set({
          "uid": user.uid,
          "name": user.displayName ?? "",
          "email": user.email ?? "",
          "phone": user.phoneNumber ?? "",
          "createdAt": FieldValue.serverTimestamp(),
        });
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e);
    } catch (e) {
      print(" Google Error: $e"); // debug
      return "Something went wrong";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  //  LOGOUT
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
  // Update Profile
  Future<String?> updateProfile({
    required String name,
    required String phone,
    String? imagePath,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final currentUser = _auth.currentUser;
      if (currentUser == null) return "User not found";

      // Name update
      await currentUser.updateDisplayName(name);

      // Firestore update
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .update({
        "name": name,
        "phone": phone,
      });

      await currentUser.reload();
      user = _auth.currentUser;

      return null;
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e);
    } catch (e) {
      print(" Update Error: $e");
      return "Something went wrong";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      isPasswordLoading = false;
      notifyListeners();

      final currentUser = _auth.currentUser;
      if (currentUser == null) return "User not found";

      final credential = EmailAuthProvider.credential(
        email: currentUser.email!,
        password: currentPassword,
      );
      await currentUser.reauthenticateWithCredential(credential);
      await currentUser.updatePassword(newPassword);

      return null;
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e);
    } catch (e) {
      return "Something went wrong";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  //  ERROR HANDLER
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return "Email already registered";
      case 'invalid-email':
        return "Invalid email format";
      case 'weak-password':
        return "Password is too weak";
      case 'user-not-found':
        return "User not found";
      case 'wrong-password':
        return "Incorrect password";
      case 'network-request-failed':
        return "Check internet connection";
      default:
        return e.message ?? "Something went wrong";
    }
  }
}
