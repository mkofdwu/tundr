import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/models/media.dart';
import 'package:tundr/widgets/buttons/back.dart';
import 'package:tundr/pages/media/widgets/media_viewer.dart';

class MediaViewPage extends StatelessWidget {
  final Media media;

  MediaViewPage({Key key, @required this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyPalette.black,
      child: Stack(
        children: <Widget>[
          MediaViewer(media: media),
          Positioned(
            left: -150,
            top: -150,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [MyPalette.black, MyPalette.transparentBlack],
                ),
              ),
            ),
          ),
          MyBackButton(iconColor: MyPalette.white),
        ],
      ),
    );
  }
}
