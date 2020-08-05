import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:tundr/models/media.dart';
import 'package:tundr/pages/media/extramediaeditpage.dart';
import 'package:tundr/services/mediapickerservice.dart';
import 'package:tundr/utils/constants/colors.dart';
import 'package:tundr/utils/constants/enums/mediatype.dart';
import 'package:tundr/utils/constants/shadows.dart';
import 'package:tundr/widgets/media/mediathumbnail.dart';
import 'package:tundr/widgets/themebuilder.dart';

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

  _editMedia(BuildContext context) async {
    if (media == null) {
      MediaType mediaType = await showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text("Take an image or a video?"),
              children: <Widget>[
                FlatButton(
                  child: Text(
                    "Image",
                    style: TextStyle(color: AppColors.white),
                  ),
                  onPressed: () => Navigator.pop(context, MediaType.image),
                ),
                FlatButton(
                  child: Text(
                    "Video",
                    style: TextStyle(color: AppColors.white),
                  ),
                  onPressed: () => Navigator.pop(context, MediaType.video),
                ),
              ],
            );
          });
      if (mediaType == null) return;
      ImageSource source = await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Select Image Source"),
            children: <Widget>[
              FlatButton(
                child: Text(
                  "Camera",
                  style: TextStyle(color: AppColors.white),
                ),
                onPressed: () => Navigator.pop(context, ImageSource.camera),
              ),
              FlatButton(
                child: Text(
                  "Gallery",
                  style: TextStyle(color: AppColors.white),
                ),
                onPressed: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          );
        },
      );
      if (source == null) return;
      final Media media = await MediaPickerService.pickMedia(
        type: mediaType,
        source: source,
        context: context,
      );
      if (media != null) onChangeMedia(media);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExtraMediaEditPage(
            media: media,
            onReplace: onChangeMedia,
            onRemove: onRemoveMedia,
          ),
        ),
      );
    }
  }

  _confirmRemoveImage(BuildContext context) async {
    // temporary fix FUTURE: improve
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Are you sure you would like to remove this image?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: onRemoveMedia,
            ),
            FlatButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLightTile() => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [Shadows.primaryShadow],
        ),
        child: media == null
            ? Center(
                child: Icon(
                  Icons.add,
                  size: 30.0,
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: MediaThumbnail(media),
              ),
      );

  Widget _buildDarkTile() => Container(
        width: size,
        height: size,
        color: AppColors.darkGrey,
        child: media == null
            ? Center(
                child: Icon(
                  Icons.add,
                  size: 30.0,
                  color: AppColors.white,
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
