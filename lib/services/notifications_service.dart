import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tundr/constants/firebase_ref.dart';

class NotificationsService {
  static Future<void> saveToken(String uid, String token) {
    return usersPrivateInfoRef.doc(uid).collection('tokens').doc(token).set({
      'timestamp': Timestamp.now(),
      'platform': Platform.operatingSystem,
    });
  }

  static Future<void> removeToken(String uid, String token) {
    return usersPrivateInfoRef
        .doc(uid)
        .collection('tokens')
        .doc(token)
        .delete();
  }
}
