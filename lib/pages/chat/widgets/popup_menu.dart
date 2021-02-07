import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tundr/enums/chat_type.dart';
import 'package:tundr/enums/media_type.dart';
import 'package:tundr/models/chat.dart';
import 'package:tundr/models/user_private_info.dart';
import 'package:tundr/store/user.dart';
import 'package:tundr/services/chats_service.dart';
import 'package:tundr/services/media_picker_service.dart';
import 'package:tundr/services/storage_service.dart';
import 'package:tundr/utils/show_question_dialog.dart';
import 'package:tundr/widgets/popup_menu.dart';

class ChatPopupMenu extends StatelessWidget {
  final Chat chat;
  final Function onUpdate;

  ChatPopupMenu({@required this.chat, @required this.onUpdate});

  void _blockAndDeleteChat(context) async {
    final confirm = await showQuestionDialog(
      context: context,
      title: 'Block and delete chat?',
      content:
          'You can unblock ${chat.otherProfile.name} later if you want, but this chat cannot be retrieved',
    );
    if (confirm) {
      Provider.of<User>(context, listen: false)
          .privateInfo
          .blocked
          .add(chat.otherProfile.uid);
      await Provider.of<User>(context, listen: false)
          .writeField('blocked', UserPrivateInfo);
      await ChatsService.deleteChat(
        Provider.of<User>(context, listen: false).profile.uid,
        chat.id,
      );
      Navigator.pop(context);
    }
  }

  void _changeWallpaper(context) async {
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
      chat.id,
      {'wallpaperUrl': wallpaperUrl},
    );
    chat.wallpaperUrl = wallpaperUrl;
    onUpdate();
  }

  void _starChat(context) {
    final uid = Provider.of<User>(context, listen: false).profile.uid;
    ChatsService.updateChatDetails(uid, chat.id, {'type': 2});
    onUpdate();
  }

  void _unstarChat(context) {
    final uid = Provider.of<User>(context, listen: false).profile.uid;
    ChatsService.updateChatDetails(uid, chat.id, {'type': 3});
    onUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenu(
      children: <Widget>[
        MenuOption(
          text: 'Wallpaper',
          onPressed: () => _changeWallpaper(context),
        ),
        if (chat.type == ChatType.normal || chat.type == ChatType.starred)
          MenuDivider(),
        if (chat.type == ChatType.normal)
          MenuOption(
            text: 'Star chat',
            onPressed: () => _starChat(context),
          )
        else if (chat.type == ChatType.starred)
          MenuOption(
            text: 'Unstar chat',
            onPressed: () => _unstarChat(context),
          ),
        MenuDivider(),
        MenuOption(
          text: 'Block and delete chat',
          onPressed: () => _blockAndDeleteChat(context),
        ),
      ],
    );
  }
}
