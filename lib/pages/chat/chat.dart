import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/chat_type.dart';
import 'package:tundr/enums/media_type.dart';
import 'package:tundr/models/chat.dart';
import 'package:tundr/models/media.dart';
import 'package:tundr/models/message.dart';
import 'package:tundr/models/user_private_info.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/pages/chat/widgets/message_field.dart';

import 'package:tundr/repositories/user.dart';
import 'package:tundr/services/chats_service.dart';
import 'package:tundr/services/media_picker_service.dart';
import 'package:tundr/services/storage_service.dart';
import 'package:tundr/utils/from_theme.dart';
import 'package:tundr/utils/get_network_image.dart';
import 'package:tundr/utils/show_question_dialog.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/popup_menus/menu_divider.dart';
import 'package:tundr/widgets/popup_menus/menu_option.dart';
import 'package:tundr/widgets/popup_menus/popup_menu.dart';

import 'widgets/other_user_message_tile.dart';
import 'widgets/own_message_tile.dart';
import 'widgets/unsent_message_tile.dart';

class ChatPage extends StatefulWidget {
  final UserProfile otherUser;
  final Chat chat;

  ChatPage({
    Key key,
    @required this.otherUser,
    @required this.chat,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  static const int messagesPerPage = 50;
  int _pages = 1;

  final ScrollController _scrollController = ScrollController();
  Media _media;
  Message _referencedMessage;
  bool _showChatOptions = false;
  final List<Message> _unsentMessages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) async {
      if (widget.chat.type != ChatType.nonExistent &&
          await ChatsService.checkReadReceipts(widget.otherUser.uid)) {
        await ChatsService.readOtherUsersMessages(
          widget.otherUser.uid,
          widget.chat.id,
        );
        if (mounted) {
          await ChatsService.updateChatDetails(
            Provider.of<User>(context, listen: false).profile.uid,
            widget.chat.id,
            {'lastRead': Timestamp.now()},
          );
        }
      }
    });
  }

  void _viewReferencedMessage(i) {
    // FUTURE: IMPLEMENT
  }

  void _deleteMessage(String messageId) {
    ChatsService.deleteMessage(
      chatId: widget.chat.id,
      messageId: messageId,
    );
  }

  void _sendMessage(String text) async {
    final profile = Provider.of<User>(context, listen: false).profile;
    final unsentMessageIndex = _unsentMessages.length;
    final sentOn = DateTime.now();

    if (_media != null) {
      _media.url =
          await StorageService.uploadMedia(uid: profile.uid, media: _media);
    }

    final message = Message(
      sender: profile,
      sentOn: sentOn,
      readOn: null,
      referencedMessage: _referencedMessage,
      text: text,
      media: _media,
    );

    setState(() {
      _unsentMessages.add(message);
    });

    final privateInfo = Provider.of<User>(context, listen: false).privateInfo;
    if (widget.chat.type == ChatType.nonExistent) {
      widget.chat.id = await ChatsService.startConversation(
        widget.otherUser.uid,
        message,
      );
    } else if (widget.chat.type == ChatType.newMatch) {
      await ChatsService.updateChatDetails(
        profile.uid,
        widget.chat.id,
        {'type': 3},
      ); // normal
      privateInfo.matches.remove(widget.otherUser.uid);
      await Provider.of<User>(context, listen: false)
          .writeField('matches', UserPrivateInfo);
    } else if (widget.chat.type == ChatType.unknown) {
      await ChatsService.updateChatDetails(
        profile.uid,
        widget.chat.id,
        {'type': 3},
      );
    }

    await ChatsService.sendMessage(widget.chat.id, message);

    if (mounted) {
      setState(() {
        widget.chat.type = ChatType.normal;
        _unsentMessages.removeAt(unsentMessageIndex);
      });
    }
  }

  void _blockAndDeleteChat() async {
    setState(() => _showChatOptions = false);
    final confirm = await showQuestionDialog(
      context: context,
      title: 'Block and delete chat?',
      content:
          'You can unblock ${widget.otherUser.name} later if you want, but this chat cannot be retrieved',
    );
    if (confirm) {
      Provider.of<User>(context, listen: false)
          .privateInfo
          .blocked
          .add(widget.otherUser.uid);
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
    setState(() => _showChatOptions = false);

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
  }

  void _starChat() {
    final uid = Provider.of<User>(context, listen: false).profile.uid;
    ChatsService.updateChatDetails(uid, widget.chat.id, {'type': 2});
  }

  void _unstarChat() {
    final uid = Provider.of<User>(context, listen: false).profile.uid;
    ChatsService.updateChatDetails(uid, widget.chat.id, {'type': 3});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _showChatOptions = false),
      child: Material(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Stack(
            children: <Widget>[
              if (widget.chat.wallpaperUrl.isEmpty)
                Container(
                  decoration: BoxDecoration(
                    gradient: fromTheme(context, dark: MyPalette.greenToBlack),
                  ),
                )
              else
                Positioned.fill(
                  child: getNetworkImage(widget.chat.wallpaperUrl),
                ),
              if (widget.chat.type != ChatType.nonExistent)
                StreamBuilder<List<Message>>(
                  stream: ChatsService.messagesStream(
                      widget.chat.id, _pages * messagesPerPage),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return SizedBox.shrink();
                    final messages = snapshot.data;
                    return NotificationListener(
                      onNotification: (ScrollNotification notification) {
                        if (notification is ScrollStartNotification &&
                            _scrollController.position.extentBefore == 0) {
                          setState(() => _pages++);
                        }
                        return false;
                      },
                      child: ListView.builder(
                        reverse: true,
                        controller: _scrollController,
                        padding: EdgeInsets.only(
                          top: 50,
                          bottom: 70.0 +
                              (_media == null ? 0 : 220) +
                              (_referencedMessage == null ? 0 : 110),
                        ),
                        itemCount: _unsentMessages.length + messages.length,
                        itemBuilder: (context, i) {
                          if (i < _unsentMessages.length) {
                            return UnsentMessageTile(
                              chatId: widget.chat.id,
                              otherUserName: widget.otherUser.name,
                              message: _unsentMessages[
                                  _unsentMessages.length - i - 1],
                            );
                          }
                          final messageIndex = i - _unsentMessages.length;
                          final message = messages[messageIndex];
                          final fromMe = message.sender.uid ==
                              Provider.of<User>(context, listen: false)
                                  .profile
                                  .uid;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Align(
                              alignment: fromMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: fromMe
                                  ? OwnMessageTile(
                                      chatId: widget.chat.id,
                                      otherUserName: widget.otherUser.name,
                                      message: message,
                                      onViewReferencedMessage: () =>
                                          _viewReferencedMessage(messageIndex),
                                      onReferenceMessage: () => setState(
                                          () => _referencedMessage = message),
                                      onDeleteMessage: () =>
                                          _deleteMessage(message.id),
                                    )
                                  : OtherUserMessageTile(
                                      chatId: widget.chat.id,
                                      otherUserName: widget.otherUser.name,
                                      profileImageUrl:
                                          widget.otherUser.profileImageUrl,
                                      message: message,
                                      viewReferencedMessage: () =>
                                          _viewReferencedMessage(messageIndex),
                                      onReferenceMessage: () => setState(
                                          () => _referencedMessage = message),
                                      onDeleteMessage: () =>
                                          _deleteMessage(message.id),
                                    ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: fromTheme(
                    context,
                    dark: MyPalette.blackToTransparent,
                    light: MyPalette.greyToTransparent,
                  ),
                ),
              ),
              SafeArea(
                child: SizedBox(
                  height: 50,
                  child: Row(
                    children: <Widget>[
                      TileIconButton(
                        icon: Icons.arrow_back,
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          child: Text(
                            widget.otherUser.name,
                            style: TextStyle(fontSize: 20),
                          ),
                          onTap: () async => Navigator.pushNamed(
                            context,
                            '/profile',
                            arguments: widget.otherUser,
                          ),
                        ),
                      ),
                      TileIconButton(
                        icon: Icons.more_vert,
                        onPressed: () =>
                            setState(() => _showChatOptions = true),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: _media == null ? 100 : 300,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: fromTheme(
                      context,
                      dark: MyPalette.transparentToBlack,
                      light: MyPalette.transparentToGrey,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                child: MessageField(
                    media: _media,
                    referencedMessage: _referencedMessage,
                    onChangeMedia: (newMedia) {
                      setState(() => _media = newMedia);
                    },
                    onSendMessage: _sendMessage),
              ),
              if (_showChatOptions)
                Positioned(
                  top: 10,
                  right: 10,
                  child: SafeArea(
                    child: PopupMenu(
                      children: <Widget>[
                        MenuOption(
                          text: 'Wallpaper',
                          onPressed: _changeWallpaper,
                        ),
                        if (widget.chat.type == ChatType.normal ||
                            widget.chat.type == ChatType.starred)
                          MenuDivider(),
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
                          text: 'Block and delete chat',
                          onPressed: _blockAndDeleteChat,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
