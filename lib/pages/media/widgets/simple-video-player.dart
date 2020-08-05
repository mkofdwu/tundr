import 'dart:io';

import "package:flutter/widgets.dart";
import 'package:tundr/models/media.dart';
import 'package:tundr/widgets/loaders/loader.dart';
import 'package:tundr/widgets/media/play-triangle.dart';
import 'package:video_player/video_player.dart';

class SimpleVideoPlayer extends StatefulWidget {
  final Media media;

  SimpleVideoPlayer({Key key, @required this.media}) : super(key: key);

  @override
  _SimpleVideoPlayerState createState() => _SimpleVideoPlayerState();
}

class _SimpleVideoPlayerState extends State<SimpleVideoPlayer> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoController;

  @override
  void initState() {
    super.initState();
    _controller = widget.media
            .isLocalFile // however, local videos are never used in the app
        ? VideoPlayerController.file(File(widget.media.url))
        : VideoPlayerController.network(widget.media.url);
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        _controller
            .seekTo(Duration.zero)
            .then((_) => _controller.pause().then((_) => setState(() {})));
      }
    });
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
          child: GestureDetector(
            onTap: () => setState(() {
              if (_controller.value.isPlaying)
                _controller.pause();
              else
                _controller.play();
            }),
            child: Stack(
              children: <Widget>[
                Hero(
                  tag: widget.media.url,
                  child: VideoPlayer(_controller),
                ),
                if (!_controller.value.isPlaying)
                  Container(color: Color(0x28FFFFFF)),
                if (_controller.value.isBuffering)
                  Center(child: Loader())
                else if (!_controller.value.isPlaying)
                  Center(child: Triangle()),
              ],
            ),
          ),
        );
      },
    );
  }
}
