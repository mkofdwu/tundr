import 'package:flutter/material.dart';
import 'package:tundr/models/media.dart';
import 'package:tundr/widgets/buttons/tileiconbutton.dart';
import 'package:tundr/widgets/media/mediaviewer.dart';

class MediaConfirmationPage extends StatelessWidget {
  final Media media;

  const MediaConfirmationPage({Key key, this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: TEST this design
    return Material(
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            Center(
              child: MediaViewer(
                media: media,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: TileIconButton(
                icon: Icons.close,
                onPressed: () => Navigator.pop(context, false),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: TileIconButton(
                icon: Icons.done,
                onPressed: () => Navigator.pop(context, true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
