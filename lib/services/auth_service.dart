import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn =
  GoogleSignIn();

  // SIGN UP
  Future<UserCredential> signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {

    final userCredential =
    await _auth
        .createUserWithEmailAndPassword(
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
      "createdAt":
      FieldValue.serverTimestamp(),
    });

    return userCredential;
  }

  // LOGIN
  Future<void> login({
    required String email,
    required String password,
  }) async {

    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  // FORGOT PASSWORD
  Future<void> forgotPassword(
      String email,
      ) async {

    await _auth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

  // GOOGLE LOGIN
  Future<User?> signInWithGoogle() async {

    final GoogleSignInAccount?
    googleUser =
    await _googleSignIn.signIn();

    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication
    googleAuth =
    await googleUser.authentication;

    final credential =
    GoogleAuthProvider.credential(
      accessToken:
      googleAuth.accessToken,
      idToken:
      googleAuth.idToken,
    );

    final userCredential =
    await _auth.signInWithCredential(
      credential,
    );

    final user = userCredential.user;

    if (user == null) return null;

    final doc = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid);

    final snapshot = await doc.get();

    if (!snapshot.exists) {

      await doc.set({
        "uid": user.uid,
        "name":
        user.displayName ?? "",
        "email":
        user.email ?? "",
        "phone":
        user.phoneNumber ?? "",
        "createdAt":
        FieldValue.serverTimestamp(),
      });
    }

    return user;
  }

  // LOGOUT
  Future<void> logout() async {

    await _googleSignIn.signOut();

    await _auth.signOut();
  }
}