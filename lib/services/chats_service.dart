import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tundr/constants/firebase_ref.dart';
import 'package:tundr/enums/chat_type.dart';
import 'package:tundr/models/chat.dart';
import 'package:tundr/models/message.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/utils/call_https_function.dart';

class ChatsService {
  static DocumentReference _userChatRef(String uid, String chatId) {
    return usersPrivateInfoRef.doc(uid).collection('chats').doc(chatId);
  }

  static Stream<List<Message>> messagesStream(String chatId, int n) {
    // stream of the last n messages
    return chatsRef
        .doc(chatId)
        .collection('messages')
        .orderBy('sentTimestamp', descending: true)
        .limit(n)
        .snapshots()
        .asyncMap((querySnapshot) {
      return Future.wait<Message>(
          querySnapshot.docs.map((doc) => Message.fromDoc(doc)));
    });
  }

  static Future<String> sendMessage(String chatId, Message message) async {
    return (await chatsRef
            .doc(chatId)
            .collection('messages')
            .add(message.toMap()))
        .id;
  }

  static Future<void> deleteMessage({
    String chatId,
    String messageId,
  }) async {
    return chatsRef.doc(chatId).collection('messages').doc(messageId).delete();
  }

  static Future<Message> getMessage(String chatId, String messageId) async {
    return await Message.fromDoc(
        await chatsRef.doc(chatId).collection('messages').doc(messageId).get());
  }

  static Future<String> startConversation(String otherUid, Message message) =>
      callHttpsFunction<String>('startConversation', {
        'otherUid': otherUid,
        'message': {
          ...message.toMap(),
          'sentOn': null, // will be determined to the server
        },
      });

  static Future<void> deleteChat(String uid, String chatId) async {
    await chatsRef.doc(chatId).update({
      'participants': FieldValue.arrayRemove([uid])
    });
    // if ((await chatsRef.doc(chatId).collection('participants').limit(1).get())
    //     .docs
    //     .isEmpty) {
    //   await chatsRef.doc(chatId).delete();
    // }
    final userChatRef = _userChatRef(uid, chatId);
    if (userChatRef.path.isNotEmpty) await userChatRef.delete();
  }

  static Future<Chat> getChatFromProfile(
      String uid, UserProfile otherProfile) async {
    final chatDocs = (await usersPrivateInfoRef
            .doc(uid)
            .collection('chats')
            .where('uid', isEqualTo: otherProfile.uid)
            .limit(1)
            .get())
        .docs;
    if (chatDocs.isEmpty) {
      return Chat(
        id: '',
        otherProfile: otherProfile,
        wallpaperUrl: '',
        lastRead: null,
        type: ChatType.nonExistent,
      );
    }
    return await Chat.fromDoc(chatDocs.first);
  }

  static Future<void> updateChatDetails(
      String uid, String chatId, Map<String, dynamic> details) {
    return _userChatRef(uid, chatId).update(details);
  }

  static Future<void> readOtherUsersMessages(String otherUid, String chatId) =>
      callHttpsFunction(
        'readOtherUsersMessages',
        {'otherUid': otherUid, 'chatId': chatId},
      );

  // using http calls to firebase cloud functions

  // true or false depending on whether both users consent to read receipts
  static Future<bool> checkReadReceipts(String otherUid) =>
      callHttpsFunction<bool>('checkReadReceipts', {'otherUid': otherUid});
}
