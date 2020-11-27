import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:tundr/constants/deleted_user.dart';
import 'package:tundr/constants/firebase_ref.dart';
import 'package:tundr/models/popular_user.dart';
import 'package:tundr/models/user_algorithm_data.dart';
import 'package:tundr/models/user_private_info.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/models/user_status.dart';
import 'package:tundr/repositories/user.dart';

Future<T> callHttpsFunction<T>(String functionName,
    [dynamic parameters]) async {
  final result = await CloudFunctions.instance
      .getHttpsCallable(functionName: functionName)
      .call(parameters);
  return result.data as T;
}

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
    if (!privateInfoDoc.exists) throw 'User private info does not exist';
    return UserPrivateInfo.fromMap(privateInfoDoc.data());
  }

  static Future<UserAlgorithmData> getUserAlgorithmData(String uid) async {
    // only fetch data from current user
    final algorithmDataDoc = await usersAlgorithmDataRef.doc(uid).get();
    if (!algorithmDataDoc.exists) {
      throw 'Algorithm data document does not exist';
    }
    return UserAlgorithmData.fromMap(algorithmDataDoc.data());
  }

  static Future<User> getUserRepo(String uid) async {
    return User(
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

  // static Future<void> setProfileField(String uid, String field, dynamic value) {
  //   return userProfilesRef.doc(uid).update({field: value});
  // }

  // static Future<void> setPrivateInfo(String uid, String field, dynamic value) {
  //   return usersPrivateInfoRef.doc(uid).update({field: value});
  // }

  // static Future<void> setAlgorithmData(
  //     String uid, String field, dynamic value) {
  //   return usersAlgorithmDataRef.doc(uid).update({field: value});
  // }

  // static Future<void> setOnline(String uid, bool online) {
  //   return userStatusesRef
  //       .doc(uid)
  //       .update({'online': true, 'lastSeen': online ? null : Timestamp.now()});
  // }

  static Future<bool> usernameAlreadyExists(String username) async {
    return (await userProfilesRef
            .where('username', isEqualTo: username)
            .limit(1)
            .get())
        .docs
        .isNotEmpty;
  }

  static Future<bool> phoneNumberExists(String phoneNumber) =>
      callHttpsFunction<bool>(
          'phoneNumberExists', {'phoneNumber': phoneNumber});

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

  static Future<bool> isBlockedBy(String otherUid) =>
      callHttpsFunction('isBlockedBy', {'otherUid': otherUid});

  static Future<List<PopularUser>> getMostPopular() async {
    final mostPopularUsers = await callHttpsFunction('getMostPopular');
    print(mostPopularUsers);
    return mostPopularUsers.map<PopularUser>((popUser) {
      final unserializedBirthday = popUser['profile']['birthday'];
      popUser['profile']['birthday'] = Timestamp(
        unserializedBirthday['_seconds'],
        unserializedBirthday['_nanoseconds'],
      );
      return PopularUser(
        profile:
            UserProfile.fromMap(Map<String, dynamic>.from(popUser['profile'])),
        popularityScore: popUser['popularityScore'],
      );
    }).toList();
  }

  static Future<bool> allowedToTalkTo(String otherUid) =>
      callHttpsFunction('allowedToTalkTo', {'otherUid': otherUid});
}
