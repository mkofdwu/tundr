import "package:flutter/material.dart";
import 'package:tundr/models/media.dart';
import 'package:tundr/widgets/media/extra-media-edit-tile.dart';

class ExtraMediaGrid extends StatelessWidget {
  final double size;
  final List<Media> extraMedia;
  final Function(int, Media) onChangeMedia;
  final Function(int) onRemoveMedia;

  ExtraMediaGrid({
    Key key,
    @required this.size,
    @required this.extraMedia,
    @required this.onChangeMedia,
    @required this.onRemoveMedia,
  }) : super(key: key);

  Widget _buildExtraMediaTile(i) => ExtraMediaEditTile(
        size: (size - 40.0) / 3,
        media: extraMedia[i],
        onChangeMedia: (media) => onChangeMedia(i, media),
        onRemoveMedia: () => onRemoveMedia(i),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildExtraMediaTile(0),
            SizedBox(width: 10.0),
            _buildExtraMediaTile(1),
            SizedBox(width: 10.0),
            _buildExtraMediaTile(2),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildExtraMediaTile(3),
            SizedBox(width: 10.0),
            _buildExtraMediaTile(4),
            SizedBox(width: 10.0),
            _buildExtraMediaTile(5),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildExtraMediaTile(6),
            SizedBox(width: 10.0),
            _buildExtraMediaTile(7),
            SizedBox(width: 10.0),
            _buildExtraMediaTile(8),
          ],
        ),
      ],
    );
  }
}
