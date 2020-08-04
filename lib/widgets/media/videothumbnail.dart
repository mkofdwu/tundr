import 'dart:io';

import "package:flutter/widgets.dart";
import 'package:tundr/models/media.dart';
import 'package:tundr/widgets/loaders/loader.dart';
import 'package:tundr/widgets/media/playtriangle.dart';
import "package:video_player/video_player.dart";

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
    assert(!widget.media
        .isInBytes); // videoplayercontroller cannot read from bytes, however local videos are never used in the app, so this should be ok on web.
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
        if (snapshot.connectionState == ConnectionState.waiting)
          return Loader();
        return AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: Stack(
            children: <Widget>[
              Hero(
                tag: widget.media.url,
                child: VideoPlayer(_controller),
              ),
              Container(color: Color(0xA0000000)),
              Center(child: Triangle()),
            ],
          ),
        );
      },
    );
  }
}
