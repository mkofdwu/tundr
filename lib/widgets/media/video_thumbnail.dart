import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:tundr/models/media.dart';
import 'package:tundr/widgets/loaders/loader.dart';
import 'package:tundr/widgets/media/play_triangle.dart';
import 'package:video_player/video_player.dart';

class VideoThumbnail extends StatefulWidget {
  final Media media;

  VideoThumbnail({Key key, @required this.media}) : super(key: key);

  @override
  _VideoThumbnailState createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoController;

  @override
  void initState() {
    super.initState();
    _controller = widget.media
            .isLocalFile // however, local videos are never used in the app
        ? VideoPlayerController.file(File(widget.media.url))
        : VideoPlayerController.network(widget.media.url);
    _initializeVideoController = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeVideoController,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loader();
        }
        return Stack(
          children: <Widget>[
            Hero(
              tag: widget.media.url,
              child: SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size?.width ?? 0,
                    height: _controller.value.size?.height ?? 0,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
            ),
            Container(color: Color.fromRGBO(0, 0, 0, 0.6)),
            Center(child: Triangle()),
          ],
        );
      },
    );
  }
}
