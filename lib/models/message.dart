import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tundr/enums/media_type.dart';

import 'media.dart';

class Message {
  String id;
  String senderUid;
  DateTime sentOn;
  DateTime readOn;
  String referencedMessageId;
  String text;
  Media media;

  Message({
    this.id,
    this.senderUid,
    this.sentOn,
    this.readOn,
    this.referencedMessageId,
    this.text,
    this.media,
  });

  factory Message.fromDoc(DocumentSnapshot doc) {
    final data = doc.data();
    return Message(
      id: doc.id,
      senderUid: data['senderUid'],
      sentOn: data['sentOn'].toDate(),
      readOn: data['readOn'].toDate(),
      referencedMessageId: data['referencedMessageId'],
      text: data['text'],
      media: data['mediaType'] == null
          ? null
          : Media(
              type: MediaType.values[data['mediaType']],
              url: data['mediaUrl'],
            ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderUid': senderUid,
      'readOn': readOn == null ? null : Timestamp.fromDate(readOn),
      'sentOn': Timestamp.fromDate(sentOn),
      'referencedMessageId': referencedMessageId,
      'text': text,
      'mediaType':
          media.type == null ? null : MediaType.values.indexOf(media.type),
      'mediaUrl': media.url,
    };
  }
}
