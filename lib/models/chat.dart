import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tundr/enums/chat_type.dart';

class Chat {
  String id;
  String uid;
  String wallpaperUrl;
  DateTime lastRead;
  ChatType type;

  Chat({
    this.id,
    this.uid,
    this.wallpaperUrl,
    this.lastRead,
    this.type,
  });

  factory Chat.fromDoc(DocumentSnapshot doc) {
    final data = doc.data();
    return Chat(
      id: doc.id,
      uid: data['uid'],
      wallpaperUrl: data['wallpaperUrl'],
      lastRead: data['lastRead'].toDate(),
      type: ChatType.values[data['type']],
    );
  }
}
