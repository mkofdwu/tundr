import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tundr/models/media.dart';
import 'package:tundr/services/media_picker_service.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/media_type.dart';
import 'package:tundr/utils/from_theme.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/pages/media/widgets/media_viewer.dart';
import 'package:tundr/widgets/popup_menus/menu_divider.dart';
import 'package:tundr/widgets/popup_menus/menu_option.dart';
import 'package:tundr/widgets/popup_menus/popup_menu.dart';

class ExtraMediaEditPage extends StatefulWidget {
  // FIXME: FUTURE: improve design
  final Media media;
  final Function(Media) onReplace;
  final Function onRemove;

  ExtraMediaEditPage({
    Key key,
    @required this.media,
    @required this.onReplace,
    @required this.onRemove,
  }) : super(key: key);

  @override
  _ExtraMediaEditPageState createState() => _ExtraMediaEditPageState();
}

class _ExtraMediaEditPageState extends State<ExtraMediaEditPage> {
  Media _media;
  bool _showOptions = false;

  @override
  void initState() {
    super.initState();
    _media = widget.media;
  }

  void _replaceWithImage() async {
    final source = await showDialog(
      context: context,
      child: SimpleDialog(
        title: Text('Select image source'),
        children: <Widget>[
          FlatButton(
            child: Text('camera'),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          FlatButton(
            child: Text('gallery'),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
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
    final source = await showDialog(
      // RETURNTOTHIS
      context: context,
      child: SimpleDialog(
        title: Text('Select video source'),
        children: <Widget>[
          FlatButton(
            child: Text('camera'),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          FlatButton(
            child: Text('gallery'),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
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
    return SafeArea(
      child: GestureDetector(
        onTap: () => setState(() => _showOptions = false),
        child: Material(
          color: MyPalette.white,
          child: Stack(
            children: <Widget>[
              Center(child: MediaViewer(media: _media)),
              fromTheme(
                context,
                dark: Container(
                  width: width,
                  height: 100.0,
                  decoration:
                      BoxDecoration(gradient: MyPalette.blackToTransparent),
                ),
                light: SizedBox.shrink(),
              ),
              TileIconButton(
                icon: Icons.arrow_back,
                onPressed: () => Navigator.pop(context),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TileIconButton(
                      icon: Icons.delete,
                      iconBackgroundColor: MyPalette.red,
                      onPressed: () {
                        widget.onRemove();
                        Navigator.pop(context);
                      },
                    ),
                    TileIconButton(
                      icon: Icons.more_vert,
                      onPressed: () => setState(() => _showOptions = true),
                    ),
                  ],
                ),
              ),
              if (_showOptions)
                Positioned(
                  top: 10.0,
                  right: 10.0,
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
              fromTheme(
                context,
                dark: Positioned(
                  bottom: 0.0,
                  child: Container(
                    width: width,
                    height: 100.0,
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
      ),
    );
  }
}

// Align(
//   alignment: Alignment.centerLeft,
//   child: Padding(
//     padding: const EdgeInsets.only(
//       left: 20.0,
//       top: 10.0,
//     ),
//     child: Text(
//       'Replace',
//       style: TextStyle(fontSize: 30.0),
//     ),
//   ),
// ),
// SizedBox(height: 10.0),
// Expanded(
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//     children: <Widget>[
//       SimpleIconButton(
//         icon: Icons.photo_camera,
//         size: 50.0,
//         onPressed: _replaceWithImage,
//       ),
//       SimpleIconButton(
//         icon: Icons.videocam,
//         size: 50.0,
//         onPressed: _replaceWithVideo,
//       ),
//     ],
//   ),
// ),
// SizedBox(height: 10.0),
// GestureDetector(
//   child: Container(
//     width: width - 20.0,
//     height: 60.0,
//     decoration: fromTheme(
//       context,
//       dark: BoxDecoration(color: AppColors.red),
//       light: BoxDecoration(
//         color: AppColors.red,
//         borderRadius: BorderRadius.circular(20.0),
//         boxShadow: [MyPalette.secondaryShadow],
//       ),
//     ),
//     child: Center(
//       child: Text(
//         'Remove',
//         style: TextStyle(
//           color: AppColors.white,
//           fontSize: 20.0,
//         ),
//       ),
//     ),
//   ),
//   onTap: () {
//     // ANIMATION
//     widget.onRemove();
//   },
// ),
// SizedBox(height: 10.0),
