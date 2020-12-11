import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/media_type.dart';
import 'package:tundr/models/media.dart';
import 'package:tundr/models/message.dart';
import 'package:tundr/services/media_picker_service.dart';
import 'package:tundr/utils/from_theme.dart';
import 'package:tundr/utils/show_options_dialog.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/media/media_thumbnail.dart';
import 'package:tundr/widgets/media/video_thumbnail.dart';
import 'package:tundr/widgets/buttons/simple_icon.dart';
import 'package:tundr/widgets/textfields/plain.dart';
import 'referenced_message_tile.dart';

class MessageField extends StatefulWidget {
  final Media media;
  final Message referencedMessage;
  final Function onRemoveMedia;
  final Function onRemoveReferencedMessage;
  final Function(Media) onChangeMedia;
  final Function(String) onSendMessage;

  MessageField({
    @required this.media,
    @required this.referencedMessage,
    @required this.onRemoveMedia,
    @required this.onRemoveReferencedMessage,
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
    _textController.addListener(() => setState(() {}));
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
    FeatureDiscovery.discoverFeatures(context, <String>['dismissible_media']);
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
        clipBehavior: Clip.antiAlias,
        child: VideoThumbnail(media: widget.media),
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
            if (widget.referencedMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: DescribedFeatureOverlay(
                  featureId: 'dismissible_reply',
                  tapTarget: SizedBox.shrink(),
                  title: Text('Swipe to remove'),
                  description:
                      Text('To remove this reply simply swipe left or right'),
                  targetColor: MyPalette.white.withOpacity(0.8),
                  backgroundColor: Theme.of(context).accentColor,
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
              ),
            if (widget.media != null)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: DescribedFeatureOverlay(
                  featureId: 'dismissible_media',
                  tapTarget: SizedBox.shrink(),
                  title: Text('Swipe to remove'),
                  description: Text(
                      'If you later decide to remove this image or video simply swipe left or right'),
                  targetColor: MyPalette.white.withOpacity(0.8),
                  backgroundColor: Theme.of(context).accentColor,
                  child: Dismissible(
                    key: Key('dismissible_media'),
                    child: fromTheme(
                      context,
                      dark: _buildMediaTileDark(),
                      light: _buildMediaTileLight(),
                    ),
                    onDismissed: (_) => widget.onRemoveMedia(),
                  ),
                ),
              ),
            Row(
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
    );
  }
}
