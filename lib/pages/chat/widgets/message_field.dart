import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/media_type.dart';
import 'package:tundr/models/media.dart';
import 'package:tundr/models/message.dart';
import 'package:tundr/services/media_picker_service.dart';
import 'package:tundr/utils/show_options_dialog.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/media/media_thumbnail.dart';
import 'package:tundr/widgets/theme_builder.dart';
import 'package:tundr/widgets/buttons/simple_icon.dart';
import 'package:tundr/widgets/textfields/plain.dart';
import 'referenced_message_tile.dart';

class MessageField extends StatefulWidget {
  final Media media;
  final Message referencedMessage;
  final Function(Media) onChangeMedia;
  final Function(String) onSendMessage;

  MessageField({
    @required this.media,
    @required this.referencedMessage,
    @required this.onChangeMedia,
    @required this.onSendMessage,
  });

  @override
  _MessageFieldState createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.addListener(() => setState(() {})); // FUTURE: optimize this
  }

  void _selectImage() async {
    // FUTURE: this and the function below are just temporary fixes, find a better solution / dialog in the future

    final source = await showOptionsDialog(
      context: context,
      title: 'Select image source',
      options: {
        'Camera': ImageSource.camera,
        'Gallery': ImageSource.gallery,
      },
    );
    if (source == null) return;
    final media = await MediaPickerService.pickMedia(
      type: MediaType.image,
      source: source,
      context: context,
    );
    if (media == null) return;
    widget.onChangeMedia(media);
  }

  void _selectVideo() async {
    final source = await showOptionsDialog(
      context: context,
      title: 'Select image source',
      options: {
        'Camera': ImageSource.camera,
        'Gallery': ImageSource.gallery,
      },
    );
    if (source == null) return;
    final media = await MediaPickerService.pickMedia(
      type: MediaType.video,
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

  Widget _buildMediaTileDark() => Container(
        width: double.infinity,
        height: 200,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          border: Border.all(color: MyPalette.white),
          boxShadow: [MyPalette.primaryShadow],
        ),
        child: MediaThumbnail(widget.media),
      );

  Widget _buildMediaTileLight() => Container(
        width: double.infinity,
        height: 200,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [MyPalette.primaryShadow],
        ), // FUTURE: DESIGN
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: MediaThumbnail(widget.media),
        ),
      );

  Widget _buildDark() => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (widget.referencedMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ReferencedMessageTile(
                  message: widget.referencedMessage,
                  borderRadius: 25,
                ),
              ),
            if (widget.media != null) _buildMediaTileDark(),
            Row(
              children: (widget.media == null
                      ? <Widget>[
                          SimpleIconButton(
                            // DESIGN: replace with a better button in the future
                            icon: Icons.photo_camera,
                            size: 30,
                            onPressed: _selectImage,
                          ),
                          SizedBox(width: 14),
                          SimpleIconButton(
                            icon: Icons.videocam,
                            size: 30,
                            onPressed: _selectVideo,
                          ),
                          SizedBox(width: 14),
                          Container(
                            width: 2,
                            height: 50,
                            color: MyPalette.white,
                          ),
                        ]
                      : <Widget>[]) +
                  <Widget>[
                    SizedBox(width: 20),
                    Expanded(
                      child: PlainTextField(
                        controller: _textController,
                        hintText: 'Say something',
                        hintTextColor: MyPalette.gold,
                        color: MyPalette.white,
                      ),
                    ),
                    SizedBox(width: 10),
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

  Widget _buildLight() => Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          decoration: BoxDecoration(
            color: MyPalette.gold,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [MyPalette.primaryShadow],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (widget.referencedMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: ReferencedMessageTile(
                      message: widget.referencedMessage,
                      borderRadius: 20,
                    ),
                  ),
                if (widget.media != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: _buildMediaTileLight(),
                  ),
                Row(
                  children: <Widget>[
                    if (widget.media == null)
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: MyPalette.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [MyPalette.primaryShadow],
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: <Widget>[
                            SimpleIconButton(
                              // DESIGN: replace with a better button in the future
                              icon: Icons.photo_camera,
                              activeColor: MyPalette.black.withOpacity(0.8),
                              onPressed: _selectImage,
                            ),
                            SizedBox(width: 10),
                            SimpleIconButton(
                              icon: Icons.videocam,
                              onPressed: _selectVideo,
                            ),
                          ],
                        ),
                      ),
                    SizedBox(width: 20),
                    Expanded(
                      child: PlainTextField(
                        controller: _textController,
                        hintText: 'Say something',
                        hintTextColor: MyPalette.white,
                        color: MyPalette.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    if (_textController.text.isNotEmpty)
                      TileIconButton(
                        icon: Icons.send,
                        iconColor: MyPalette.white,
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
    return ThemeBuilder(
      buildDark: _buildDark,
      buildLight: _buildLight,
    );
  }
}
