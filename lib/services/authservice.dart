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
      print("returned user: ${result.user.email}");
      return result.user != null;
    } on PlatformException catch (exception) {
      print(exception.message);
      return false;
    } on AuthException catch (exception) {
      print(exception.message);
      return false;
    } on Exception catch (exception) {
      print(exception.runtimeType);
      return false;
    } catch (e) {
      print(e.runtimeType);
      return false;
    }
  }

  static Future<void> signOut() => FirebaseAuth.instance.signOut();

  static Future<void> deleteAccount() async =>
      (await FirebaseAuth.instance.currentUser()).delete();

  static Future<bool> changePassword({
    String currentUid,
    String currentUsername,
    String currentPassword,
    String newPassword,
  }) async {
    try {
      AuthResult res = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "$currentUsername@example.com",
        password: currentPassword,
      );
      if (res.user.uid == currentUid) {
        res.user.updatePassword(newPassword);
        return true;
      }
      return false;
    } on PlatformException catch (exception) {
      print("error: " + exception.message);
      return false;
    }
  }
}
