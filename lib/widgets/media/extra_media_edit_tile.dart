import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tundr/models/media.dart';
import 'package:tundr/pages/media/edit_extra_media.dart';
import 'package:tundr/services/media_picker_service.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/media_type.dart';
import 'package:tundr/utils/show_options_dialog.dart';
import 'package:tundr/utils/show_question_dialog.dart';
import 'package:tundr/widgets/media/media_thumbnail.dart';
import 'package:tundr/widgets/theme_builder.dart';

class ExtraMediaEditTile extends StatelessWidget {
  final double size;
  final Media media;
  final Function(Media) onChangeMedia;
  final Function onRemoveMedia;

  ExtraMediaEditTile({
    Key key,
    @required this.size,
    @required this.media,
    @required this.onChangeMedia,
    @required this.onRemoveMedia,
  }) : super(key: key);

  void _editMedia(BuildContext context) async {
    if (media == null) {
      final mediaType = await showOptionsDialog(
        context: context,
        title: 'Take an image or a video?',
        options: {
          'Image': MediaType.image,
          'Video': MediaType.video,
        },
      );
      if (mediaType == null) return;
      final source = await showOptionsDialog(
        context: context,
        title: 'Select a source',
        options: {
          'Camera': ImageSource.camera,
          'Gallery': ImageSource.gallery,
        },
      );
      if (source == null) return;
      final media = await MediaPickerService.pickMedia(
        type: mediaType,
        source: source,
        context: context,
      );
      if (media != null) onChangeMedia(media);
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditExtraMediaPage(
            media: media,
            onReplace: onChangeMedia,
            onRemove: onRemoveMedia,
          ),
        ),
      );
    }
  }

  void _confirmRemoveImage(BuildContext context) async {
    final confirm = await showQuestionDialog(
      context: context,
      title: 'Are you sure you would like to remove this image?',
    );
    if (confirm) onRemoveMedia();
  }

  Widget _buildLightTile() => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: MyPalette.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [MyPalette.primaryShadow],
        ),
        child: media == null
            ? Center(
                child: Icon(
                  Icons.add,
                  size: 30,
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: MediaThumbnail(media),
              ),
      );

  Widget _buildDarkTile() => Container(
        width: size,
        height: size,
        color: MyPalette.darkGrey,
        child: media == null
            ? Center(
                child: Icon(
                  Icons.add,
                  size: 30,
                  color: MyPalette.white,
                ),
              )
            : MediaThumbnail(media),
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ThemeBuilder(
        buildDark: _buildDarkTile,
        buildLight: _buildLightTile,
      ),
      onTap: () => _editMedia(context),
      onLongPress: () => _confirmRemoveImage(context),
    );
  }
}
