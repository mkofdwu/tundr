import 'package:flutter/material.dart';
import 'package:tundr/models/media.dart';
import 'package:tundr/constants/colors.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/pages/media/widgets/media_viewer.dart';

class MediaViewPage extends StatelessWidget {
  final Media media;

  MediaViewPage({Key key, this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Center(child: MediaViewer(media: media)),
          Positioned(
            left: -150.0,
            top: -150.0,
            child: Container(
              width: 300.0,
              height: 300.0,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppColors.black,
                    AppColors.transparentBlack,
                  ],
                ),
              ),
            ),
          ),
          TileIconButton(
            icon: Icons.arrow_back,
            iconColor: AppColors.white,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
