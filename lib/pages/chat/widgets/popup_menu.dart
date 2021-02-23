import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v2.dart' as drive;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tundr/enums/chat_type.dart';
import 'package:tundr/enums/media_type.dart';
import 'package:tundr/models/chat.dart';
import 'package:tundr/models/user_private_info.dart';
import 'package:tundr/pages/chat/services/google_auth_client.dart';
import 'package:tundr/store/user.dart';
import 'package:tundr/services/chats_service.dart';
import 'package:tundr/services/media_picker_service.dart';
import 'package:tundr/services/storage_service.dart';
import 'package:tundr/utils/show_info_dialog.dart';
import 'package:tundr/utils/show_question_dialog.dart';
import 'package:tundr/widgets/popup_menu.dart';

class ChatPopupMenu extends StatefulWidget {
  final Chat chat;
  final Function onUpdate;
  final Function onSuccessfullyExportChat;

  ChatPopupMenu({
    @required this.chat,
    @required this.onUpdate,
    @required this.onSuccessfullyExportChat,
  });

  @override
  _ChatPopupMenuState createState() => _ChatPopupMenuState();
}

class _ChatPopupMenuState extends State<ChatPopupMenu> {
  void _deleteChat() async {
    final confirm = await showQuestionDialog(
      context: context,
      title: 'Delete chat?',
      content: 'You won\'t be able to undo this action',
    );
    if (confirm) {
      await ChatsService.deleteChat(
        Provider.of<User>(context, listen: false).profile.uid,
        widget.chat.id,
      );
      Navigator.pop(context);
    }
  }

  void _blockAndDeleteChat() async {
    final confirm = await showQuestionDialog(
      context: context,
      title: 'Block and delete chat?',
      content:
          'You can unblock ${widget.chat.otherProfile.name} later if you want, but this chat cannot be retrieved',
    );
    if (confirm) {
      Provider.of<User>(context, listen: false)
          .privateInfo
          .blocked
          .add(widget.chat.otherProfile.uid);
      await Provider.of<User>(context, listen: false)
          .writeField('blocked', UserPrivateInfo);
      await ChatsService.deleteChat(
        Provider.of<User>(context, listen: false).profile.uid,
        widget.chat.id,
      );
      Navigator.pop(context);
    }
  }

  void _changeWallpaper() async {
    final imageMedia = await MediaPickerService.pickMedia(
      type: MediaType.image,
      source: ImageSource.gallery,
      context: context,
    );

    if (imageMedia == null) return;

    final uid = Provider.of<User>(context, listen: false).profile.uid;
    final wallpaperUrl = await StorageService.uploadMedia(
      uid: uid,
      media: imageMedia,
    );
    await ChatsService.updateChatDetails(
      uid,
      widget.chat.id,
      {'wallpaperUrl': wallpaperUrl},
    );
    widget.chat.wallpaperUrl = wallpaperUrl;
    widget.onUpdate();
  }

  void _starChat() {
    final uid = Provider.of<User>(context, listen: false).profile.uid;
    ChatsService.updateChatDetails(uid, widget.chat.id, {'type': 2});
    widget.chat.type = ChatType.starred;
    widget.onUpdate();
  }

  void _unstarChat() {
    final uid = Provider.of<User>(context, listen: false).profile.uid;
    ChatsService.updateChatDetails(uid, widget.chat.id, {'type': 3});
    widget.chat.type = ChatType.normal;
    widget.onUpdate();
  }

  Future<void> _exportChat() async {
    widget.onUpdate();
    final userProfile = Provider.of<User>(context, listen: false).profile;
    final googleSignIn =
        GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
    final account = await googleSignIn.signIn();
    final authHeaders = await account.authHeaders;
    final driveApi = drive.DriveApi(GoogleAuthClient(authHeaders));
    final chatHistoryString =
        await ChatsService.getChatHistory(widget.chat, userProfile);
    final mediaStream =
        Stream.value(chatHistoryString.codeUnits).asBroadcastStream();
    final media = drive.Media(mediaStream, chatHistoryString.length);
    final driveFile = drive.File();
    driveFile.title = 'tundr chat with ${widget.chat.otherProfile.name}.txt';
    final uploadedFile =
        await driveApi.files.insert(driveFile, uploadMedia: media);
    if (uploadedFile != null) {
      widget.onSuccessfullyExportChat();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenu(
      children: <Widget>[
        MenuOption(
          text: 'Wallpaper',
          onPressed: _changeWallpaper,
        ),
        if (widget.chat.type == ChatType.normal)
          MenuOption(
            text: 'Star chat',
            onPressed: _starChat,
          )
        else if (widget.chat.type == ChatType.starred)
          MenuOption(
            text: 'Unstar chat',
            onPressed: _unstarChat,
          ),
        MenuDivider(),
        MenuOption(
          text: 'Export chat',
          onPressed: _exportChat,
        ),
        MenuDivider(),
        MenuOption(
          text: 'Delete chat',
          onPressed: _deleteChat,
        ),
        MenuOption(
          text: 'Block and delete chat',
          onPressed: _blockAndDeleteChat,
        ),
      ],
    );
  }
}
