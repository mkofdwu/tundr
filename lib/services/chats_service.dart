import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:tundr/constants/firebase_ref.dart';
import 'package:tundr/enums/chat_type.dart';
import 'package:tundr/enums/media_type.dart';
import 'package:tundr/models/chat.dart';
import 'package:tundr/models/message.dart';
import 'package:tundr/models/user_private_info.dart';

class ChatsService {
  static DocumentReference _userChatRef(String uid, String chatId) {
    return usersPrivateInfoRef.doc(uid).collection('chats').doc(chatId);
  }

  static Stream<QuerySnapshot> messagesStream(String chatId, int n) {
    // stream of last n messages
    return chatsRef
        .doc(chatId)
        .collection('messages')
        .orderBy('sentTimestamp', descending: true)
        .limit(n)
        .snapshots();
  }

  static Future<String> sendMessage({
    String chatId,
    String fromUid,
    String toUid,
    DateTime sentTimestamp,
    String referencedMessageId = '',
    String text,
    MediaType mediaType,
    String mediaUrl,
  }) async {
    return (await chatsRef.doc(chatId).collection('messages').add({
      'senderUid': fromUid,
      'sentTimestamp': Timestamp.fromDate(sentTimestamp),
      'readTimestamp': null,
      'referencedMessageId': referencedMessageId,
      'text': text,
      'mediaType':
          mediaType == null ? null : MediaType.values.indexOf(mediaType),
      'mediaUrl': mediaUrl,
    }))
        .id;
  }

  static Future<void> deleteMessage({
    String chatId,
    String messageId,
  }) async {
    return chatsRef.doc(chatId).collection('messages').doc(messageId).delete();
  }

  static Future<Message> getMessage(String chatId, String messageId) async {
    return Message.fromDoc(
        await chatsRef.doc(chatId).collection('messages').doc(messageId).get());
  }

  static Future<String> startConversation(
      String uid, String otherUid, Message message) async {
    final result = await CloudFunctions.instance
        .getHttpsCallable(functionName: 'startConversation')
        .call({'otherUid': otherUid, 'message': message.toMap()});
    return result.data;
  }

  static Future<void> deleteChat(String uid, String chatId) async {
    await chatsRef.doc(chatId).update({
      'participants': FieldValue.arrayRemove([uid])
    });
    // if ((await chatsRef.doc(chatId).collection('participants').limit(1).get())
    //     .docs
    //     .isEmpty) {
    //   await chatsRef.doc(chatId).delete();
    // }
    await _userChatRef(uid, chatId).delete();
  }

  static Future<Chat> getChatFromUid(String uid, String otherUid) async {
    final chatDocs = (await usersPrivateInfoRef
            .doc(uid)
            .collection('chats')
            .where('uid', isEqualTo: otherUid)
            .limit(1)
            .get())
        .docs;
    if (chatDocs.isEmpty) {
      return Chat(
        id: '',
        uid: otherUid,
        wallpaperUrl: '',
        lastReadTimestamp: null,
        type: ChatType.nonExistent,
      );
    }
    return Chat.fromDoc(chatDocs.first);
  }

  static Future<int> updateChatDetails(
      {String uid, String chatId, Map<String, dynamic> details}) {
    return _userChatRef(uid, chatId).update(details);
  }

  static Future<void> updateChatMessagesRead(
      String chatId, String otherUid) async {
    return Future.wait((await chatsRef
            .doc(chatId)
            .collection('messages')
            .where('senderUid', isEqualTo: otherUid)
            .where('readTimestamp', isNull: true)
            .get())
        .docs
        .map(
            (doc) => doc.reference.update({'readTimestamp': Timestamp.now()})));
  }

  // using http calls to firebase cloud functions

  static Future<bool> checkReadReceipts(String otherUid) async {
    final callable = CloudFunctions.instance
        .getHttpsCallable(functionName: 'checkReadReceipts');
    final result = await callable.call({otherUid: otherUid});
    return result
        .data; // true or false depending on whether both users consent to read receipts
  }
}
