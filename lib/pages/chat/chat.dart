import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/chat_type.dart';
import 'package:tundr/models/chat.dart';
import 'package:tundr/models/media.dart';
import 'package:tundr/models/message.dart';
import 'package:tundr/models/user_status.dart';
import 'package:tundr/pages/chat/widgets/message_field.dart';
import 'package:tundr/pages/chat/widgets/popup_menu.dart';

import 'package:tundr/repositories/user.dart';
import 'package:tundr/services/chats_service.dart';
import 'package:tundr/services/storage_service.dart';
import 'package:tundr/services/users_service.dart';
import 'package:tundr/utils/format_date.dart';
import 'package:tundr/utils/from_theme.dart';
import 'package:tundr/utils/get_network_image.dart';
import 'package:tundr/utils/show_info_dialog.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/my_feature.dart';

import 'widgets/message_tile.dart';
import 'widgets/unsent_message_tile.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

  ChatPage({
    Key key,
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

  final Map<String, GlobalKey> messageIdToGlobalKey = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) async {
      if (widget.chat.type != ChatType.nonExistent &&
          widget.chat.type != ChatType.newMatch) {
        if (Provider.of<User>(context, listen: false)
            .privateInfo
            .settings
            .readReceipts) {
          // only send read receipts if the user's settings allows
          await ChatsService.readOtherUsersMessages(
            widget.chat.otherProfile.uid,
            widget.chat.id,
          );
        }
      }
      if (mounted) {
        FeatureDiscovery.discoverFeatures(context, <String>['message_tile']);
      }
    });
  }

  @override
  void deactivate() {
    print('chat page deactivated');
    ChatsService.updateLastReadMessageId(
      Provider.of<User>(context, listen: false).profile.uid,
      widget.chat.id,
    );
    super.deactivate();
  }

  void _viewReferencedMessage(messageId) {
    if (messageIdToGlobalKey.containsKey(messageId)) {
      Scrollable.ensureVisible(
        messageIdToGlobalKey[messageId].currentContext,
        duration: Duration(milliseconds: 400),
        alignment: 0.8, // 80% from the bottom of the screen
      );
    } else {
      showInfoDialog(
        context: context,
        title: 'Could not find message',
        content:
            "It's likely this message has not been loaded yet. Try scrolling to the top to view more messages.",
      );
    }
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

    final message = Message(
      sender: profile,
      sentOn: sentOn,
      readOn: null,
      referencedMessage: _referencedMessage,
      text: text,
      media: _media,
    );

    setState(() {
      _media = null;
      _referencedMessage = null;
      _unsentMessages.add(message);
      widget.chat.lastReadMessageId = null;
    });

    if (message.media != null) {
      message.media.url = await StorageService.uploadMedia(
          uid: profile.uid, media: message.media);
      message.media.isLocalFile = false;
    }

    if (widget.chat.type == ChatType.nonExistent) {
      widget.chat.id = await ChatsService.startConversation(
        widget.chat.otherProfile.uid,
        message,
      );
    } else if (widget.chat.type == ChatType.newMatch) {
      await ChatsService.updateChatDetails(
        profile.uid,
        widget.chat.id,
        {'type': 3},
      ); // normal
    } else if (widget.chat.type == ChatType.unknown) {
      await ChatsService.updateChatDetails(
        profile.uid,
        widget.chat.id,
        {'type': 3},
      );
    }

    if (widget.chat.type != ChatType.nonExistent) {
      // when calling the startConversation http function a message is already created
      await ChatsService.sendMessage(widget.chat.id, message);
    }

    if (mounted) {
      setState(() {
        widget.chat.type = ChatType.normal;
        _unsentMessages.removeAt(unsentMessageIndex);
      });
    }
  }

  Widget _buildUserStatusText() => StreamBuilder<UserStatus>(
        stream: UsersService.getUserStatusStream(widget.chat.otherProfile.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return SizedBox.shrink();
          final status = snapshot.data;
          return Text(
            status.online ? 'online' : formatDate(status.lastSeen),
            style: TextStyle(fontSize: 12, color: MyPalette.white),
          );
        },
      );

  Widget _buildTopBar() => SizedBox(
        height: 50,
        child: Row(
          children: <Widget>[
            TileIconButton(
              icon: Icons.arrow_back,
              iconColor: MyPalette.white,
              onPressed: () => Navigator.pop(context),
            ),
            SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chat.otherProfile.name,
                      style: TextStyle(fontSize: 20, color: MyPalette.white),
                    ),
                    StreamBuilder<bool>(
                      stream: ChatsService.otherUserIsTypingStream(widget.chat),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return SizedBox.shrink();
                        if (snapshot.data) {
                          return Text(
                            'typing',
                            style: TextStyle(
                              fontSize: 12,
                              color: MyPalette.white,
                            ),
                          );
                        }
                        return _buildUserStatusText();
                      },
                    ),
                  ],
                ),
                onTap: () async => Navigator.pushNamed(
                  context,
                  '/profile',
                  arguments: widget.chat.otherProfile,
                ),
              ),
            ),
            TileIconButton(
              icon: Icons.more_vert,
              iconColor: MyPalette.white,
              onPressed: () => setState(() => _showChatOptions = true),
            ),
          ],
        ),
      );

  Widget _buildMessagesList() => StreamBuilder<List<Message>>(
        stream: widget.chat.type == ChatType.nonExistent ||
                widget.chat.type == ChatType.newMatch
            ? null
            : ChatsService.messagesStream(
                widget.chat.id, _pages * messagesPerPage),
        builder: (context, snapshot) {
          final messages = snapshot.data ?? [];
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
                top: 100,
                bottom: 120.0 +
                    (_media == null ? 0 : 220) +
                    (_referencedMessage == null ? 0 : 160),
              ),
              itemCount: _unsentMessages.length + messages.length,
              itemBuilder: (context, i) {
                if (i < _unsentMessages.length) {
                  return UnsentMessageTile(
                    message: _unsentMessages[_unsentMessages.length - i - 1],
                  );
                }
                final messageIndex = i - _unsentMessages.length;
                final message = messages[messageIndex];
                final fromMe = message.sender.uid ==
                    Provider.of<User>(context, listen: false).profile.uid;
                assert(message.id != null);
                messageIdToGlobalKey[message.id] = GlobalKey();

                return Column(
                  children: [
                    Align(
                      alignment:
                          fromMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: MyFeature(
                          featureId: 'message_tile',
                          tapTarget: SizedBox.shrink(),
                          title: 'Message options',
                          description:
                              'Long press on this message tile to delete or reply to it',
                          child: MessageTile(
                            key: messageIdToGlobalKey[
                                message.id], // ValueKey(message.id),
                            message: message,
                            fromMe: fromMe,
                            readReceipts: Provider.of<User>(context)
                                .privateInfo
                                .settings
                                .readReceipts,
                            onViewReferencedMessage: () {
                              _viewReferencedMessage(
                                  message.referencedMessage.id);
                            },
                            onReferenceMessage: () {
                              setState(() => _referencedMessage = message);
                              FeatureDiscovery.discoverFeatures(
                                  context, <String>['dismissible_reply']);
                            },
                            onDeleteMessage: () {
                              _deleteMessage(message.id);
                            },
                          ),
                        ),
                      ),
                    ),
                    if (message.id == widget.chat.lastReadMessageId && i > 0)
                      _buildUnreadMessagesLabel(i),
                  ],
                );
              },
            ),
          );
        },
      );

  Widget _buildUnreadMessagesLabel(numUnreadMessages) => Container(
        height: 40,
        margin: const EdgeInsets.symmetric(vertical: 5),
        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
        child: Center(child: Text('$numUnreadMessages unread messages')),
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _showChatOptions = false),
      child: Material(
        // color: Color.fromRGBO(240, 240, 240, 1),
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
              _buildMessagesList(),
              Container(
                height: 140,
                decoration: BoxDecoration(
                  gradient: fromTheme(
                    context,
                    dark: MyPalette.blackToTransparent,
                    light: MyPalette.greyToTransparent,
                  ),
                ),
              ),
              SafeArea(
                child: _buildTopBar(),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: _media == null ? 140 : 300,
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
                child: FutureBuilder<bool>(
                    future:
                        UsersService.isBlockedBy(widget.chat.otherProfile.uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 40,
                            right: 40,
                            bottom: 30,
                          ),
                          child: Text(
                            'You can no longer send messages to this chat because ' +
                                widget.chat.otherProfile.name +
                                ' blocked you.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: MyPalette.white,
                            ),
                          ),
                        );
                      }
                      return MessageField(
                        media: _media,
                        referencedMessage: _referencedMessage,
                        onRemoveMedia: () {
                          setState(() => _media = null);
                        },
                        onRemoveReferencedMessage: () {
                          setState(() => _referencedMessage = null);
                        },
                        onChangeMedia: (newMedia) {
                          setState(() => _media = newMedia);
                        },
                        onSendMessage: _sendMessage,
                        onStartTyping: () => ChatsService.toggleTyping(
                          widget.chat.id,
                          Provider.of<User>(context, listen: false).profile.uid,
                          true,
                        ),
                        onStopTyping: () => ChatsService.toggleTyping(
                          widget.chat.id,
                          Provider.of<User>(context, listen: false).profile.uid,
                          false,
                        ),
                      );
                    }),
              ),
              if (_showChatOptions)
                Positioned(
                  top: 10,
                  right: 10,
                  child: SafeArea(
                    child: ChatPopupMenu(chat: widget.chat),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
