import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tundr/models/media.dart';
import 'package:tundr/services/media_picker_service.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/media_type.dart';
import 'package:tundr/utils/from_theme.dart';
import 'package:tundr/utils/show_options_dialog.dart';
import 'package:tundr/utils/show_question_dialog.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/pages/media/widgets/media_viewer.dart';
import 'package:tundr/widgets/popup_menu.dart';

class EditExtraMediaPage extends StatefulWidget {
  final Media media;
  final Function(Media) onReplace;
  final Function onRemove;

  EditExtraMediaPage({
    Key key,
    @required this.media,
    @required this.onReplace,
    @required this.onRemove,
  }) : super(key: key);

  @override
  _EditExtraMediaPageState createState() => _EditExtraMediaPageState();
}

class _EditExtraMediaPageState extends State<EditExtraMediaPage> {
  Media _media;
  bool _showOptions = false;

  @override
  void initState() {
    super.initState();
    _media = widget.media;
  }

  void _confirmRemove() async {
    final confirm = await showQuestionDialog(
      context: context,
      title:
          'Remove this ${_media.type == MediaType.image ? "image" : "video"}?',
      content: 'This action cannot be undone.',
    );
    if (confirm) {
      widget.onRemove();
      Navigator.pop(context);
    }
  }

  void _replaceWithImage() async {
    final source = await showOptionsDialog(
      context: context,
      title: 'Select image source',
      options: {
        'Camera': ImageSource.camera,
        'Gallery': ImageSource.gallery,
      },
    );
    if (source == null) return;
    final imageMedia = await MediaPickerService.pickMedia(
      type: MediaType.image,
      source: source,
      context: context,
    );
    if (imageMedia == null) return;
    setState(() {
      _media = imageMedia;
      _showOptions = false;
    });
    widget.onReplace(_media);
  }

  void _replaceWithVideo() async {
    final source = await showOptionsDialog(
      context: context,
      title: 'Select video source',
      options: {
        'Camera': ImageSource.camera,
        'Gallery': ImageSource.gallery,
      },
    );
    if (source == null) return;
    final videoMedia = await MediaPickerService.pickMedia(
      type: MediaType.video,
      source: source,
      context: context,
    );
    if (videoMedia != null) {
      setState(() {
        _media = videoMedia;
        _showOptions = false;
      });
      widget.onReplace(_media);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => setState(() => _showOptions = false),
      child: Material(
        child: Stack(
          children: <Widget>[
            MediaViewer(media: _media),
            fromTheme(
              context,
              dark: Container(
                width: width,
                height: 100,
                decoration:
                    BoxDecoration(gradient: MyPalette.blackToTransparent),
              ),
              light: SizedBox.shrink(),
            ),
            SafeArea(
              child: TileIconButton(
                icon: Icons.arrow_back,
                onPressed: () => Navigator.pop(context),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TileIconButton(
                      icon: Icons.delete,
                      iconBackgroundColor: MyPalette.red,
                      onPressed: _confirmRemove,
                    ),
                    TileIconButton(
                      icon: Icons.more_vert,
                      onPressed: () => setState(() => _showOptions = true),
                    ),
                  ],
                ),
              ),
            ),
            if (_showOptions)
              Positioned(
                top: 10,
                right: 10,
                child: SafeArea(
                  child: PopupMenu(
                    children: <Widget>[
                      MenuOption(
                        text: 'Replace with image',
                        onPressed: _replaceWithImage,
                      ),
                      MenuDivider(),
                      MenuOption(
                        text: 'Replace with video',
                        onPressed: _replaceWithVideo,
                      ),
                    ],
                  ),
                ),
              ),
            fromTheme(
              context,
              dark: Positioned(
                bottom: 0,
                child: Container(
                  width: width,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        MyPalette.black,
                        MyPalette.transparentBlack,
                      ],
                    ),
                  ),
                ),
              ),
              light: SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
