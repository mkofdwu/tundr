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
    assert(doc != null);
    return Chat(
      id: doc.documentID,
      uid: doc.data['uid'],
      wallpaperUrl: doc.data['wallpaperUrl'],
      lastReadTimestamp: doc.data['lastReadTimestamp'],
      type: doc.data['type'],
    );
  }
}
