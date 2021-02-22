import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/media_type.dart';
import 'package:tundr/models/media.dart';
import 'package:tundr/models/message.dart';
import 'package:tundr/services/media_picker_service.dart';
import 'package:tundr/utils/from_theme.dart';
import 'package:tundr/utils/show_options_dialog.dart';
import 'package:tundr/widgets/media/media_thumbnail.dart';
import 'package:tundr/widgets/buttons/simple_icon.dart';
import 'package:tundr/widgets/my_feature.dart';
import 'referenced_message_tile.dart';

class MessageField extends StatefulWidget {
  final Media media;
  final Message referencedMessage;
  final Function onRemoveMedia;
  final Function onRemoveReferencedMessage;
  final Function(Media) onChangeMedia;
  final Function(String) onSendMessage;
  final Function onStartTyping;
  final Function onStopTyping;

  MessageField({
    @required this.media,
    @required this.referencedMessage,
    @required this.onRemoveMedia,
    @required this.onRemoveReferencedMessage,
    @required this.onChangeMedia,
    @required this.onSendMessage,
    @required this.onStartTyping,
    @required this.onStopTyping,
  });

  @override
  _MessageFieldState createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  final TextEditingController _textController = TextEditingController();
  bool _isTyping = false;
  Timer _stopTypingTimer;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _textController.dispose();
    _stopTypingTimer?.cancel();
    if (_isTyping) {
      widget.onStopTyping();
      _isTyping = false;
    }
    super.dispose();
  }

  void _selectMedia(MediaType type) async {
    final source = await showOptionsDialog(
      context: context,
      title: "Select ${type == MediaType.image ? 'image' : 'video'} source",
      options: {
        'Camera': ImageSource.camera,
        'Gallery': ImageSource.gallery,
      },
    );
    if (source == null) return;
    final media = await MediaPickerService.pickMedia(
      type: type,
      source: source,
      context: context,
    );
    if (media == null) return;
    widget.onChangeMedia(media);
  }

  void _sendMessage() {
    widget.onSendMessage(_textController.text);
    setState(() {
      _textController.text = '';
    });
  }

  Widget _buildAttachedMedia() => Padding(
        padding: const EdgeInsets.only(top: 5),
        child: MyFeature(
          key: ValueKey('dismissibleMediaFeature'),
          featureId: 'dismissible_media',
          tapTarget: SizedBox.shrink(),
          title: 'Swipe to remove',
          description:
              'If you later decide to remove this image or video simply swipe left or right',
          child: Dismissible(
            key: Key('dismissible_media'),
            child: Container(
              width: double.infinity,
              height: 200,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: fromTheme(
                context,
                light: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [MyPalette.primaryShadow],
                ),
                dark: BoxDecoration(
                  border: Border.all(color: MyPalette.white),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: MediaThumbnail(widget.media),
            ),
            onDismissed: (_) => widget.onRemoveMedia(),
          ),
        ),
      );

  Widget _buildReferencedMessage() => Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: MyFeature(
          key: ValueKey('dismissibleReplyFeature'),
          featureId: 'dismissible_reply',
          tapTarget: SizedBox.shrink(),
          title: 'Swipe to remove',
          description: 'To remove this reply simply swipe left or right',
          child: Dismissible(
            key: Key('dismissible_reply'),
            child: ReferencedMessageTile(
              message: widget.referencedMessage,
              fontSize: 20,
              borderRadius: 20,
            ),
            onDismissed: (_) => widget.onRemoveReferencedMessage(),
          ),
        ),
      );

  Widget _buildTextField() => TextField(
        controller: _textController,
        cursorColor: MyPalette.white,
        style: TextStyle(
          color: MyPalette.white,
          fontSize: 20,
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.only(bottom: 8),
          hintText: 'Say something',
          hintStyle: TextStyle(color: MyPalette.white, fontSize: 20),
          border: InputBorder.none,
        ),
        minLines: 1,
        maxLines: 4,
        onChanged: (_) {
          if (!_isTyping) {
            widget.onStartTyping();
            _isTyping = true;
          }

          _stopTypingTimer?.cancel();
          _stopTypingTimer = Timer(
            Duration(
              seconds: 3,
            ), // if not typing for 3 seconds the user is considered to have stopped typing
            () {
              widget.onStopTyping();
              _isTyping = false;
            },
          );
        },
      );

  Widget _buildMediaSelectorAndTextField() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            if (widget.media == null)
              Container(
                height: 40,
                decoration: fromTheme(
                  context,
                  dark: BoxDecoration(
                    border: Border(
                      right: BorderSide(width: 2, color: MyPalette.white),
                    ),
                  ),
                  light: BoxDecoration(
                    color: MyPalette.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [MyPalette.primaryShadow],
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: <Widget>[
                    SimpleIconButton(
                      icon: Icons.photo_camera,
                      activeColor: MyPalette.black.withOpacity(0.8),
                      onPressed: () => _selectMedia(MediaType.image),
                    ),
                    SizedBox(width: 10),
                    SimpleIconButton(
                      icon: Icons.videocam,
                      activeColor: MyPalette.black.withOpacity(0.8),
                      onPressed: () => _selectMedia(MediaType.video),
                    ),
                  ],
                ),
              ),
            SizedBox(width: 20),
            Expanded(
              child: _buildTextField(),
            ),
            SizedBox(width: 10),
            if (_textController.text.isNotEmpty)
              GestureDetector(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(Icons.send, color: MyPalette.white),
                ),
                onTap: _sendMessage,
              )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: fromTheme(
          context,
          dark: null,
          light: BoxDecoration(
            color: MyPalette.gold,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [MyPalette.primaryShadow],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (widget.referencedMessage != null) _buildReferencedMessage(),
            if (widget.media != null) _buildAttachedMedia(),
            _buildMediaSelectorAndTextField(),
          ],
        ),
      ),
    );
  }
}
