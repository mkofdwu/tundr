import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthService {
  static Future<bool> signIn({
    String username,
    String password,
  }) async {
    try {
      print(
          "signing in with email: $username@example.com and password: $password");
      AuthResult result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: "$username@example.com", password: password);

      return result.user != null;
    } catch (e) {
      return false;
    }
  }

  static Future<void> signOut() => FirebaseAuth.instance.signOut();

  static Future<void> deleteAccount() async =>
      (await FirebaseAuth.instance.currentUser()).delete();

  static Future<bool> changePassword({
    String userUid,
    String userUsername,
    String oldPassword,
    String newPassword,
  }) async {
    try {
      // TODO: is this correct?
      AuthResult res = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "$userUsername@example.com",
        password: oldPassword,
      );
      if (res.user.uid == userUid) {
        res.user.updatePassword(newPassword);
        return true;
      }
      return false;
    } on PlatformException {
      return false;
    }
  }
}
