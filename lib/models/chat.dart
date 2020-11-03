import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tundr/enums/chat_type.dart';

class Chat {
  String id;
  String uid;
  String wallpaperUrl;
  DateTime lastReadTimestamp;
  ChatType type;

  Chat({
    this.id,
    this.uid,
    this.wallpaperUrl,
    this.lastReadTimestamp,
    this.type,
  });

  factory Chat.fromDoc(DocumentSnapshot doc) {
    final data = doc.data();
    return Chat(
      id: doc.id,
      uid: data['uid'],
      wallpaperUrl: data['wallpaperUrl'],
      lastReadTimestamp: data['lastReadTimestamp'],
      type: data['type'],
    );
  }
}
