import 'package:flutter/material.dart';
import 'package:tundr/models/media.dart';
import 'package:tundr/widgets/buttons/back.dart';
import 'package:tundr/pages/media/widgets/media_viewer.dart';

class MediaViewPage extends StatelessWidget {
  final Media media;

  MediaViewPage({Key key, @required this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        MediaViewer(media: media),
        MyBackButton(),
      ],
    );
  }
}
