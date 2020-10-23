import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tundr/constants/colors.dart';
import 'package:tundr/constants/gradients.dart';
import 'package:tundr/constants/shadows.dart';
import 'package:tundr/enums/chat_type.dart';
import 'package:tundr/enums/media_type.dart';
import 'package:tundr/models/chat.dart';
import 'package:tundr/models/media.dart';
import 'package:tundr/models/message.dart';
import 'package:tundr/models/user.dart';
import 'package:tundr/repositories/current_user.dart';
import 'package:tundr/services/database_service.dart';
import 'package:tundr/services/media_picker_service.dart';
import 'package:tundr/services/storage_service.dart';
import 'package:tundr/utils/from_theme.dart';
import 'package:tundr/utils/get_network_image.dart';
import 'package:tundr/widgets/buttons/simple_icon.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/media/media_thumbnail.dart';
import 'package:tundr/widgets/popup_menus/menu_divider.dart';
import 'package:tundr/widgets/popup_menus/menu_option.dart';
import 'package:tundr/widgets/popup_menus/popup_menu.dart';
import 'package:tundr/widgets/textfields/plain.dart';
import 'package:tundr/widgets/theme_builder.dart';

import 'widgets/other_user_message_tile.dart';
import 'widgets/own_message_tile.dart';
import 'widgets/referenced_message_tile.dart';
import 'widgets/unsent_message_tile.dart';

class ChatPage extends StatefulWidget {
  final User user;
  final Chat chat;

  ChatPage({
    Key key,
    @required this.user,
    @required this.chat,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  static const int messagesPerPage = 50;
  int _pages = 1;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  // Timer _updater;
  String _referencedMessageId;
  Media _media;
  bool _showChatOptions = false;
  final List<Message> _unsentMessages = [];

  @override
  void initState() {
    super.initState();
    _textController.addListener(() => setState(() {})); // FUTURE: optimize this
    SchedulerBinding.instance.addPostFrameCallback((duration) async {
      final user = Provider.of<CurrentUser>(context).user;

      if (widget.chat.type != ChatType.nonExistent &&
          user.readReceipts &&
          widget.user.readReceipts) {
        // does this take too much time?
        // FUTURE: TEST: send read receipts in real time
        await DatabaseService.updateChatMessagesRead(
            widget.chat.uid, widget.user.uid);
        if (mounted) {
          await DatabaseService.setChatLastRead(user.uid, widget.chat.id);
        }
      }

      // _updater = Timer.periodic(Duration(seconds: 1),
      //     (timer) => setState(() {}));
    });
  }

  @override
  void dispose() {
    // _updater.cancel();
    super.dispose();
  }

  void _selectImage() async {
    // FUTURE: this and the function below are just temporary fixes, find a better solution / dialog in the future
    final source = await showDialog(
      context: context,
      child: SimpleDialog(
        title: Text('Select image source'),
        children: <Widget>[
          FlatButton(
            child: Text('Camera'),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          FlatButton(
            child: Text('Gallery'),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );
    if (source == null) return;
    final media = await MediaPickerService.pickMedia(
      type: MediaType.image,
      source: source,
      context: context,
    );
    if (media == null) return;
    setState(() => _media = media);
  }

  void _selectVideo() async {
    final source = await showDialog(
      context: context,
      child: SimpleDialog(
        title: Text('Select video source'),
        children: <Widget>[
          FlatButton(
            child: Text('Camera'),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          FlatButton(
            child: Text('Gallery'),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );
    if (source == null) return;
    final media = await MediaPickerService.pickMedia(
      type: MediaType.video,
      source: source,
      context: context,
    );
    if (media == null) return;
    setState(() => _media = media);
  }

  void _viewReferencedMessage(i) {
    // FUTURE: IMPLEMENT
  }

  void _deleteMessage(String messageId) {
    // FUTURE: ask if delete for self or delete for everyone
    DatabaseService.deleteMessage(
      chatId: widget.chat.id,
      messageId: messageId,
    );
  }

  void _sendMessage() async {
    final uid = Provider.of<CurrentUser>(context).user.uid;
    final text = _textController
        .text; // copy the value of the text to clear the textfield and thus prevent spamming empty messages
    final referencedMessageId = _referencedMessageId;
    final media = _media;

    final unsentMessageIndex = _unsentMessages.length;
    final sentTimestamp = DateTime.now();

    setState(() {
      _textController.text = '';
      _referencedMessageId = null;
      _media = null;
      _unsentMessages.add(Message(
        sentTimestamp: sentTimestamp,
        referencedMessageId: referencedMessageId,
        text: text,
        media: media,
      ));
    });

    if (widget.chat.type == ChatType.nonExistent) {
      widget.chat.id =
          await DatabaseService.startConversation(uid, widget.user.uid);
    } else if (widget.chat.type == ChatType.newMatch) {
      widget.chat.id =
          await DatabaseService.addNormalChat(uid, widget.user.uid);
      await DatabaseService.removeMatch(uid, widget.user.uid);
    } else if (widget.chat.type == ChatType.unknown) {
      widget.chat.id =
          await DatabaseService.addNormalChat(uid, widget.user.uid);
      await DatabaseService.removeUnknownChat(uid, widget.chat.id);
    }

    // String mediaUrl = mediaFile == null
    //     ? ''
    //     : mediaFile.absolute.path.isEmpty
    //         ? ''
    //         : await StorageService.uploadMedia(
    //             uid: uid,
    //             media: Media(
    //               type: mediaType,
    //               url: mediaFile.absolute.path,
    //               isLocalFile: true,
    //             ),
    //           );

    final mediaUrl = media == null
        ? ''
        : await StorageService.uploadMedia(
            uid: uid,
            media: media,
          );

    await DatabaseService.sendMessage(
      chatId: widget.chat.id,
      fromUid: uid,
      toUid: widget.user.uid,
      sentTimestamp: sentTimestamp,
      referencedMessageId: referencedMessageId,
      text: text,
      mediaType: media.type,
      mediaUrl: mediaUrl,
    );

    if (mounted) {
      setState(() {
        widget.chat.type = ChatType.normal;
        _unsentMessages.removeAt(unsentMessageIndex);
      });
    }
  }

  void _blockUser() {
    DatabaseService.blockUser(
        Provider.of<CurrentUser>(context).user.uid, widget.user.uid);
    _deleteChat();
  }

  void _deleteChat() {
    DatabaseService.deleteChat(
      Provider.of<CurrentUser>(context).user.uid,
      widget.chat.id,
    );
    Navigator.pop(context);
  }

  void _changeWallpaper() async {
    setState(() => _showChatOptions = false);

    final imageMedia = await MediaPickerService.pickMedia(
      type: MediaType.image,
      source: ImageSource.gallery,
      context: context,
    );

    if (imageMedia == null) return;

    final uid = Provider.of<CurrentUser>(context).user.uid;
    final wallpaperUrl = await StorageService.uploadMedia(
      uid: uid,
      media: imageMedia,
    );
    await DatabaseService.setChatWallpaper(uid, widget.chat.id, wallpaperUrl);
  }

  Widget _buildMediaTileDark() {
    return Container(
      width: double.infinity,
      height: 200.0,
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.white),
        boxShadow: [Shadows.primaryShadow],
      ),
      child: MediaThumbnail(_media),
    );
  }

  Widget _buildMediaTileLight() {
    return Container(
      width: double.infinity,
      height: 200.0,
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: const [Shadows.primaryShadow],
      ), // FUTURE: DESIGN
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.0),
        child: MediaThumbnail(_media),
      ),
    );
  }

  Widget _buildMessageInputDark() => Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _referencedMessageId == null
                ? SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: ReferencedMessageTile(
                      chatId: widget.chat.id,
                      messageId: _referencedMessageId,
                      otherUserName: widget.user.name,
                      borderRadius: 25.0,
                    ),
                  ),
            _media == null ? SizedBox.shrink() : _buildMediaTileDark(),
            Row(
              children: (_media == null
                      ? <Widget>[
                          SimpleIconButton(
                            // DESIGN: replace with a better button in the future
                            icon: Icons.photo_camera,
                            onPressed: _selectImage,
                          ),
                          SizedBox(width: 10.0),
                          SimpleIconButton(
                            icon: Icons.videocam,
                            onPressed: _selectVideo,
                          ),
                          SizedBox(width: 10.0),
                          Container(
                            width: 2.0,
                            height: 50.0,
                            color: AppColors.white,
                          ),
                        ]
                      : <Widget>[]) +
                  <Widget>[
                    SizedBox(width: 20.0),
                    Expanded(
                      child: PlainTextField(
                        controller: _textController,
                        hintText: 'Say something',
                        hintTextColor: AppColors.gold,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    if (_textController.text.isNotEmpty)
                      TileIconButton(
                        icon: Icons.send,
                        onPressed: _sendMessage,
                      ),
                  ],
            ),
          ],
        ),
      );

  Widget _buildMessageInputLight() => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(35.0),
            boxShadow: [Shadows.primaryShadow],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _referencedMessageId == null
                    ? SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: ReferencedMessageTile(
                          chatId: widget.chat.id,
                          messageId: _referencedMessageId,
                          otherUserName: widget.user.name,
                          borderRadius: 25.0,
                        ),
                      ),
                _media == null ? SizedBox.shrink() : _buildMediaTileLight(),
                Row(
                  children: <Widget>[
                    if (_media == null)
                      Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(25.0),
                          boxShadow: [Shadows.primaryShadow],
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            SimpleIconButton(
                              // DESIGN: replace with a better button in the future
                              icon: Icons.photo_camera,
                              size: 30.0,
                              onPressed: _selectImage,
                            ),
                            SizedBox(width: 10.0),
                            SimpleIconButton(
                              icon: Icons.videocam,
                              size: 30.0,
                              onPressed: _selectVideo,
                            ),
                          ],
                        ),
                      ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: PlainTextField(
                        controller: _textController,
                        hintText: 'Say something',
                        hintTextColor: AppColors.white,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    if (_textController.text.isNotEmpty)
                      TileIconButton(
                        icon: Icons.send,
                        onPressed: _sendMessage,
                      )
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => setState(() => _showChatOptions = false),
        child: Material(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Stack(
              children: <Widget>[
                if (widget.chat.wallpaperUrl.isEmpty)
                  Container(
                    decoration: BoxDecoration(
                      gradient:
                          fromTheme(context, dark: Gradients.greenToBlack),
                    ),
                  )
                else
                  Positioned.fill(
                    child: getNetworkImage(widget.chat.wallpaperUrl),
                  ),
                if (widget.chat.type != ChatType.nonExistent)
                  StreamBuilder<QuerySnapshot>(
                    stream: DatabaseService.messagesStream(
                        widget.chat.id, _pages * messagesPerPage),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return SizedBox.shrink();
                      final messages = snapshot.data.documents
                          .map((messageDoc) => Message.fromDoc(messageDoc))
                          .toList();
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
                            top: 50.0,
                            bottom: 70.0 +
                                (_media == null ? 0 : 220.0) +
                                (_referencedMessageId == null ? 0 : 110.0),
                          ),
                          itemCount: _unsentMessages.length + messages.length,
                          itemBuilder: (context, i) {
                            if (i < _unsentMessages.length) {
                              return UnsentMessageTile(
                                chatId: widget.chat.id,
                                otherUserName: widget.user.name,
                                message: _unsentMessages[
                                    _unsentMessages.length - i - 1],
                              );
                            }
                            final messageIndex = i - _unsentMessages.length;
                            final message = messages[messageIndex];
                            final fromMe = message.senderUid ==
                                Provider.of<CurrentUser>(context).user.uid;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 10.0,
                              ),
                              child: Align(
                                alignment: fromMe
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: fromMe
                                    ? OwnMessageTile(
                                        chatId: widget.chat.id,
                                        otherUserName: widget.user.name,
                                        message: message,
                                        onViewReferencedMessage: () =>
                                            _viewReferencedMessage(
                                                messageIndex),
                                        onReferenceMessage: () => setState(() =>
                                            _referencedMessageId = message.id),
                                        onDeleteMessage: () =>
                                            _deleteMessage(message.id),
                                      )
                                    : OtherUserMessageTile(
                                        chatId: widget.chat.id,
                                        otherUserName: widget.user.name,
                                        profileImageUrl:
                                            widget.user.profileImageUrl,
                                        message: message,
                                        viewReferencedMessage: () =>
                                            _viewReferencedMessage(
                                                messageIndex),
                                        onReferenceMessage: () => setState(() =>
                                            _referencedMessageId = message.id),
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
                  height: 100.0,
                  decoration: BoxDecoration(
                    gradient: fromTheme(
                      context,
                      dark: Gradients.blackToTransparent,
                      light: Gradients.greyToTransparent,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                  child: Row(
                    children: <Widget>[
                      TileIconButton(
                        icon: Icons.arrow_back,
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: GestureDetector(
                          child: Text(
                            widget.user.name,
                            style: TextStyle(fontSize: 20.0),
                          ),
                          onTap: () async => Navigator.pushNamed(
                            context,
                            'userprofile',
                            arguments: widget.user,
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
                Positioned(
                  bottom: 0.0,
                  child: Container(
                    height: _media == null ? 100.0 : 300.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: fromTheme(
                        context,
                        dark: Gradients.transparentToBlack,
                        light: Gradients.transparentToGrey,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  width: MediaQuery.of(context).size.width,
                  child: ThemeBuilder(
                    buildDark: _buildMessageInputDark,
                    buildLight: _buildMessageInputLight,
                  ),
                ),
                if (_showChatOptions)
                  Positioned(
                    top: 10.0,
                    right: 10.0,
                    child: PopupMenu(
                      children: <Widget>[
                        MenuOption(
                          text: 'Block',
                          onPressed: _blockUser,
                        ),
                        MenuDivider(),
                        MenuOption(
                          text: 'Delete',
                          onPressed: _deleteChat,
                        ),
                        MenuDivider(),
                        MenuOption(
                          text: 'Wallpaper',
                          onPressed: _changeWallpaper,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
