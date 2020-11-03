import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tundr/enums/media_type.dart';

import 'media.dart';

class Message {
  String id;
  String senderUid;
  DateTime sentTimestamp;
  DateTime readTimestamp;
  String referencedMessageId;
  String text;
  Media media;

  Message({
    this.id,
    this.senderUid,
    this.sentTimestamp,
    this.readTimestamp,
    this.referencedMessageId,
    this.text,
    this.media,
  });

  factory Message.fromDoc(DocumentSnapshot doc) {
    final data = doc.data();
    return Message(
      id: doc.id,
      senderUid: data['senderUid'],
      sentTimestamp: data['sentTimestamp'].toDate(),
      readTimestamp: data['readTimestamp'].toDate(),
      referencedMessageId: data['referencedMessageId'],
      text: data['text'],
      media: data['mediaType'] == null
          ? null
          : Media(
              type: MediaType.values.elementAt(data['mediaType']),
              url: data['mediaUrl'],
            ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': senderUid,
      'readTimestamp': readTimestamp?.millisecondsSinceEpoch,
      'sentTimestamp': sentTimestamp.millisecondsSinceEpoch,
      'referencedMessageId': referencedMessageId,
      'text': text,
      'mediaType':
          media.type == null ? null : MediaType.values.indexOf(media.type),
      'mediaUrl': media.url,
    };
  }
}
