import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:tundr/constants/deleted_user.dart';
import 'package:tundr/constants/firebase_ref.dart';
import 'package:tundr/models/user_algorithm_data.dart';
import 'package:tundr/models/user_private_info.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/models/user_status.dart';
import 'package:tundr/repositories/current_user.dart';

class UsersService {
  static Future<UserProfile> getUserProfile(
    String uid, {
    bool returnDeletedUser = true,
  }) async {
    final userDoc = await userProfilesRef.doc(uid).get();
    return userDoc.exists
        ? UserProfile.fromMap(userDoc.data())
        : (returnDeletedUser ? deletedUserProfile : null);
  }

  static Future<UserPrivateInfo> getUserPrivateInfo(String uid) async {
    // only used for current user
    final privateInfoDoc = await usersPrivateInfoRef.doc(uid).get();
    return UserPrivateInfo.fromDoc(privateInfoDoc);
  }

  static Future<UserAlgorithmData> getUserAlgorithmData(String uid) async {
    // only fetch data from current user
    final algorithmDataDoc = await usersAlgorithmDataRef.doc(uid).get();
    return UserAlgorithmData.fromMap(algorithmDataDoc.data());
  }

  static Future<CurrentUser> getCurrentUser(String uid) async {
    return CurrentUser(
      profile: await getUserProfile(uid),
      privateInfo: await getUserPrivateInfo(uid),
      algorithmData: await getUserAlgorithmData(uid),
    );
  }

  static Stream<UserStatus> getUserStatusStream(String uid) {
    return userStatusesRef
        .doc(uid)
        .snapshots()
        .map((userStatusDoc) => UserStatus.fromMap(userStatusDoc.data()));
  }

  static Future<void> setProfileField(String uid, String field, dynamic value) {
    return userProfilesRef.doc(uid).update({field: value});
  }

  static Future<void> setPrivateInfo(String uid, String field, dynamic value) {
    return usersPrivateInfoRef.doc(uid).update({field: value});
  }

  static Future<void> setAlgorithmData(
      String uid, String field, dynamic value) {
    return usersAlgorithmDataRef.doc(uid).update({field: value});
  }

  static Future<void> setOnline(String uid, bool online) {
    return userStatusesRef
        .doc(uid)
        .update({'online': true, 'lastSeen': online ? null : Timestamp.now()});
  }

  static Future<bool> usernameAlreadyExists(String username) async {
    return (await userProfilesRef
            .where('username', isEqualTo: username)
            .limit(1)
            .get())
        .docs
        .isNotEmpty;
  }

  static Future<bool> phoneNumberExists(String phoneNumber) async {
    return (await usersPrivateInfoRef
            .where('phoneNumber', isEqualTo: phoneNumber)
            .limit(1)
            .get())
        .docs
        .isNotEmpty;
  }

  static Future<List<UserProfile>> searchForUsers(
      String partialUsername, int n) async {
    final users = <UserProfile>[];
    final uids = <String>[];
    ((await userProfilesRef
                    .where('username',
                        isGreaterThanOrEqualTo: partialUsername.toLowerCase())
                    .limit(n ~/ 2)
                    .get())
                .docs +
            (await userProfilesRef
                    .where('username',
                        isGreaterThanOrEqualTo: partialUsername.toUpperCase())
                    .limit(n ~/ 2)
                    .get())
                .docs)
        .forEach((userDoc) {
      final profile = userDoc.data();
      if (profile['username']
              .toLowerCase()
              .startsWith(partialUsername.toLowerCase()) &&
          !uids.contains(profile['uid'])) {
        users.add(UserProfile.fromMap(profile));
        uids.add(profile['uid']);
      }
    });
    return users;
  }

  static Future<bool> isBlockedBy(String otherUid) async {
    final callable =
        CloudFunctions.instance.getHttpsCallable(functionName: 'isBlockedBy');
    final result = await callable.call({'otherUid': otherUid});
    return result.data;
  }

  // TODO: watch user's unknown messages and check if user is blocked
}
