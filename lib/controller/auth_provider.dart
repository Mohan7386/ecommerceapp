import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {

  final AuthService _authService =
  AuthService();

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  bool isLoading = false;

  bool isPasswordLoading = false;
  bool _isInitialized = false;

  bool get isInitialized =>
      _isInitialized;

  User? user;

  AuthProvider() {
    _auth.authStateChanges().listen(
          (User? currentUser) {
        user = currentUser;
        _isInitialized = true;
        notifyListeners();
      },
    );
  }

  // LOGIN CHECK
  bool get isLoggedIn =>
      user != null;

  // SIGN UP
  Future<String?> signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {

    try {

      isLoading = true;
      notifyListeners();
      await _authService.signUp(
        name: name,
        phone: phone,
        email: email,
        password: password,
      );

      return null;

    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e);

    } catch (e) {
      debugPrint(
        "Signup Error: $e",
      );
      return "Something went wrong";

    } finally {

      isLoading = false;

      notifyListeners();
    }
  }

  // LOGIN
  Future<String?> login({
    required String email,
    required String password,
  }) async {

    try {

      isLoading = true;

      notifyListeners();

      await _authService.login(
        email: email,
        password: password,
      );

      return null;

    } on FirebaseAuthException catch (e) {

      return _handleAuthError(e);

    } catch (e) {

      debugPrint(
        "Login Error: $e",
      );

      return "Something went wrong";

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // FORGOT PASSWORD
  Future<String?> forgotPassword(
      String email,
      ) async {

    try {
      isLoading = true;
      notifyListeners();
      await _authService
          .forgotPassword(email);
      return null;
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e);
    } catch (e) {

      debugPrint(
        "Forgot Password Error: $e",
      );
      return "Something went wrong";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // GOOGLE SIGN IN
  Future<String?> signInWithGoogle()
  async {

    try {
      isLoading = true;
      notifyListeners();

      final user =
      await _authService
          .signInWithGoogle();

      if (user == null) {

        return "User cancelled login";
      }
      return null;

    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e);
    } catch (e) {
      debugPrint(
        "Google Sign In Error: $e",
      );
      return "Something went wrong";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _authService.logout();
  }

  // UPDATE PROFILE
  Future<String?> updateProfile({
    required String name,
    required String phone,
  }) async {

    try {

      isLoading = true;
      notifyListeners();
      final currentUser =
          _auth.currentUser;
      if (currentUser == null) {
        return "User not found";
      }

      await currentUser
          .updateDisplayName(name);
      user = _auth.currentUser;
      return null;

    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e);
    } catch (e) {

      debugPrint(
        "Update Profile Error: $e",
      );
      return "Something went wrong";

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // CHANGE PASSWORD
  Future<String?> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {

    try {
      isPasswordLoading = true;
      notifyListeners();

      final currentUser =
          _auth.currentUser;

      if (currentUser == null) {
        return "User not found";
      }

      final credential =
      EmailAuthProvider.credential(
        email: currentUser.email!,
        password: currentPassword,
      );

      await currentUser
          .reauthenticateWithCredential(
        credential,
      );

      await currentUser
          .updatePassword(newPassword);
      return null;

    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e);

    } catch (e) {

      debugPrint(
        "Change Password Error: $e",
      );
      return "Something went wrong";

    } finally {
      isPasswordLoading = false;
      notifyListeners();
    }
  }

  // ERROR HANDLER
  String _handleAuthError(
      FirebaseAuthException e,
      ) {

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
        return e.message ??
            "Something went wrong";
    }
  }
}