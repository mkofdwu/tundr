import 'package:tundr/constants/firebase_ref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:tundr/enums/media_type.dart';
import 'package:tundr/models/media.dart';
import 'package:tundr/models/user_algorithm_data.dart';
import 'package:tundr/models/user_private_info.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/repositories/registration_info.dart';
import 'package:tundr/services/storage_service.dart';

class AuthService {
  static Future<bool> signIn({
    String username,
    String password,
  }) async {
    try {
      print(
          'signing in with email: $username@example.com and password: $password');
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: '$username@example.com', password: password);

      return result.user != null;
    } catch (e) {
      return false;
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
    } on PlatformException {
      return false;
    }
  }

  static Future<void> createAccount(RegistrationInfo info) async {
    final profileImageUrl = await StorageService.uploadMedia(
      uid: info.uid,
      media: info.profilePic,
      prefix: 'profile_image',
    );

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

    info.profilePic.url = profileImageUrl;
    info.profilePic.isLocalFile = false;

    await userProfilesRef.doc(info.uid).set(UserProfile.register(info).toMap());
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
  }
}
