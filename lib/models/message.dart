import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tundr/enums/media_type.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/services/chats_service.dart';
import 'package:tundr/services/users_service.dart';

import 'media.dart';

class Message {
  String id;
  String chatId;
  UserProfile sender;
  String text;
  Media media;
  Message referencedMessage;
  DateTime sentOn;
  DateTime readOn;

  Message({
    this.id,
    this.chatId,
    this.sender,
    this.text,
    this.media,
    this.referencedMessage,
    this.sentOn,
    this.readOn,
  });

  static Future<Message> fromDoc(DocumentSnapshot doc) async {
    final map = doc.data();
    final chatId = doc.reference.parent.parent.id;
    return Message(
      id: doc.id,
      chatId: chatId,
      sender: await UsersService.getUserProfile(map['senderUid']),
      text: map['text'],
      media: map['mediaType'] == null
          ? null
          : Media(
              type: MediaType.values[map['mediaType']],
              url: map['mediaUrl'],
            ),
      referencedMessage:
          await ChatsService.getMessage(chatId, map['referencedMessageId']),
      sentOn: map['sentOn'].toDate(),
      readOn: map['readOn'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderUid': sender.uid,
      'text': text,
      'mediaType': media == null ? null : MediaType.values.indexOf(media.type),
      'mediaUrl': media?.url,
      'referencedMessageId': referencedMessage?.id,
      'readOn': readOn == null ? null : Timestamp.fromDate(readOn),
      'sentOn': Timestamp.fromDate(sentOn),
    };
  }
}
