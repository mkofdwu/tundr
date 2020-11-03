import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tundr/constants/firebase_ref.dart';

class NotificationsService {
  static Future<void> saveToken(String uid, String token) {
    return userProfilesRef.doc(uid).collection('tokens').doc(token).setData({
      'timestamp': Timestamp.now(),
      'platform': Platform.operatingSystem,
    });
  }

  static Future<void> removeToken(String uid, String token) {
    return usersRef.doc(uid).collection('tokens').doc(token).delete();
  }
}
