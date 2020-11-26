import 'package:flutter/services.dart';
import 'package:tundr/constants/firebase_ref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tundr/models/user_algorithm_data.dart';
import 'package:tundr/models/user_private_info.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/repositories/registration_info.dart';
import 'package:tundr/services/storage_service.dart';

class AuthService {
  static Stream<User> currentUserStream() =>
      FirebaseAuth.instance.authStateChanges();

  static Future<String> signIn({
    String username,
    String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: '$username@example.com', password: password);
      return null;
    } catch (e) {
      return e.message;
    }
  }

  static Future<void> signOut() => FirebaseAuth.instance.signOut();

  static Future<void> deleteAccount(String uid) async {
    return Future.wait([
      FirebaseAuth.instance.currentUser.delete(),
      // remove from cloud firestore
      usersPrivateInfoRef.doc(uid).delete(),
      usersAlgorithmDataRef.doc(uid).delete(),
      userProfilesRef.doc(uid).delete(),
      userStatusesRef.doc(uid).delete(),
    ]);
  }

  static Future<bool> changePassword({
    String userUid,
    String userUsername,
    String oldPassword,
    String newPassword,
  }) async {
    try {
      // TODO: is this correct?
      final res = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: '$userUsername@example.com',
        password: oldPassword,
      );
      if (res.user.uid == userUid) {
        await res.user.updatePassword(newPassword);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // phone registration

  static Future<void> _uploadLocalPhotos(RegistrationInfo info) async {
    final profileImageUrl = await StorageService.uploadMedia(
      uid: info.uid,
      media: info.profilePic,
      prefix: 'profile_image',
    );

    info.profilePic.url = profileImageUrl;
    info.profilePic.isLocalFile = false;

    for (final media in info.extraMedia) {
      if (media != null) {
        media.url = await StorageService.uploadMedia(
          uid: info.uid,
          media: media,
          prefix: 'extra_media',
        );
        media.isLocalFile = false;
      }
    }
  }

  static Future<bool> _createAccount({
    RegistrationInfo info,
    AuthCredential phoneCredential,
  }) async {
    try {
      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: '${info.username.trim()}@example.com',
          password: info.password);
      if (result.user == null) {
        return false;
      } else {
        info.uid = result.user.uid;
        await _uploadLocalPhotos(info);
        print(info);
        print(UserProfile.register(info).toMap());
        print(UserPrivateInfo.register(info).toMap());
        print(UserAlgorithmData.register(info).toMap());
        await userProfilesRef
            .doc(info.uid)
            .set(UserProfile.register(info).toMap());
        await usersPrivateInfoRef
            .doc(info.uid)
            .set(UserPrivateInfo.register(info).toMap());
        await usersAlgorithmDataRef
            .doc(info.uid)
            .set(UserAlgorithmData.register(info).toMap());
        await userStatusesRef.doc(info.uid).set({
          'online': true,
          'lastSeen': null,
        });
        await result.user.updatePhoneNumber(phoneCredential);
        return true;
      }
    } on PlatformException catch (exception) {
      print(exception.message);
      await FirebaseAuth.instance.signOut(); // FUTURE: temporary fix
      return false;
    }
  }

  static Future<bool> verifyCodeAndCreateAccount(RegistrationInfo info,
      List<int> verificationCode, String verificationId) async {
    if (!verificationCode.contains(null)) {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: verificationCode.join(),
      );
      if (credential != null) {
        return _createAccount(info: info, phoneCredential: credential);
      }
    }
    return false;
  }

  static void sendSMS(
      RegistrationInfo info, Function(String) verificationIdCallback) {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: info.phoneNumber,
      timeout: const Duration(seconds: 120),
      verificationCompleted: (AuthCredential credential) {
        _createAccount(info: info, phoneCredential: credential);
      },
      verificationFailed: (FirebaseAuthException exception) {
        print('verification failed: ' + exception.message);
      },
      codeSent: (String verificationId, int forceResendingToken) {
        verificationIdCallback(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationIdCallback(verificationId);
      },
    );
  }
}
