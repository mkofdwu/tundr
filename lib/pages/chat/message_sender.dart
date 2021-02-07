import 'package:flutter/widgets.dart';
import 'package:tundr/enums/chat_type.dart';
import 'package:tundr/models/chat.dart';
import 'package:tundr/models/message.dart';
import 'package:tundr/services/chats_service.dart';
import 'package:tundr/services/storage_service.dart';

class MessageSender {
  final String uid; // authenticated user's id
  final Chat chat;
  final Function onUpdate;

  final List<Message> unsentMessages = [];

  MessageSender({
    @required this.uid,
    @required this.chat,
    this.onUpdate,
  });

  Future<void> send(Message message) async {
    unsentMessages.add(message);

    if (chat.type == ChatType.nonExistent) {
      // chat hasn't been created yet
      if (unsentMessages.length == 1) {
        await _createChatThenSendUnsentMessages(message);
      } else {
        // do nothing, wait for chat to be created
      }
    } else {
      // send the message
      await _uploadMessageMedia(message);
      await ChatsService.sendMessage(chat.id, message);
      // update chat type
      if (chat.type == ChatType.newMatch || chat.type == ChatType.unknown) {
        chat.type = ChatType.normal;
        await ChatsService.updateChatDetails(uid, chat.id, {'type': 3});
      }
      unsentMessages.remove(message);
    }
  }

  Future<void> _createChatThenSendUnsentMessages(Message firstMessage) async {
    // this is the first message sent, create a chat
    await _uploadMessageMedia(firstMessage);
    chat.id = await ChatsService.startConversation(
      chat.otherProfile.uid,
      firstMessage,
    );
    unsentMessages.remove(firstMessage);
    // done creating chat, send unsent messages
    for (final unsent in List.from(unsentMessages)) {
      await _uploadMessageMedia(unsent);
      await ChatsService.sendMessage(chat.id, firstMessage);
      unsentMessages.remove(unsent);
    }
    chat.type = ChatType.normal;

    // TEMPORARY FIX:
    // for some reason the unsent messages update previously but not here
    if (onUpdate != null) onUpdate();
  }

  Future<void> _uploadMessageMedia(Message message) async {
    if (message.media != null && message.media.isLocalFile) {
      message.media.url =
          await StorageService.uploadMedia(uid: uid, media: message.media);
      message.media.isLocalFile = false;
    }
  }
}
