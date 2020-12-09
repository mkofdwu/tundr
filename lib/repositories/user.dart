import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tundr/constants/firebase_ref.dart';
import 'package:tundr/models/chat.dart';
import 'package:tundr/models/user_algorithm_data.dart';
import 'package:tundr/models/user_private_info.dart';
import 'package:tundr/models/user_profile.dart';

class User {
  UserProfile profile;
  UserPrivateInfo privateInfo;
  UserAlgorithmData algorithmData;
  String fcmToken;

  User({this.profile, this.privateInfo, this.algorithmData});

  bool get loggedIn =>
      profile != null && privateInfo != null && algorithmData != null;

  Future<void> updateProfile(Map<String, dynamic> data) async {
    final profileMap = profile.toMap()..addAll(data);
    profile = UserProfile.fromMap(profileMap);
    await userProfilesRef.doc(profile.uid).update(data);
    // notifyListeners();
  }

  Future<void> updatePrivateInfo(Map<String, dynamic> data) async {
    final privateInfoMap = privateInfo.toMap()..addAll(data);
    privateInfo = UserPrivateInfo.fromMap(privateInfoMap);
    await usersPrivateInfoRef.doc(profile.uid).update(data);
    // notifyListeners();
  }

  Future<void> updateAlgorithmData(Map<String, dynamic> data) async {
    final algorithmDataMap = algorithmData.toMap()..addAll(data);
    algorithmData = UserAlgorithmData.fromMap(algorithmDataMap);
    await usersAlgorithmDataRef.doc(profile.uid).update(data);
    // notifyListeners();
  }

  Future<void> updateOnline(bool online) {
    return userStatusesRef
        .doc(profile.uid)
        .update({'online': true, 'lastSeen': online ? null : Timestamp.now()});
  }

  Future<void> writeField(String field, Type type) async {
    // save field value to database
    var collectionRef;
    var value;
    if (type == UserProfile) {
      collectionRef = userProfilesRef;
      value = profile.toMap()[field];
    } else if (type == UserPrivateInfo) {
      collectionRef = usersPrivateInfoRef;
      value = privateInfo.toMap()[field];
    } else if (type == UserAlgorithmData) {
      collectionRef = usersAlgorithmDataRef;
      value = algorithmData.toMap()[field];
    }
    await collectionRef.doc(profile.uid).update({field: value});
  }

  Future<void> writeFields(List<String> fields, Type type) async {
    for (final field in fields) {
      await writeField(field, type);
    }
  }

  Stream<List<Chat>> chatsStream() {
    return usersPrivateInfoRef
        .doc(profile.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((querySnapshot) =>
            Future.wait(querySnapshot.docs.map((doc) => Chat.fromDoc(doc))));
  }
}
