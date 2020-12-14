import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/models/media.dart';
import 'package:tundr/widgets/my_loader.dart';
import 'package:tundr/widgets/media/play_triangle.dart';
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
      setState(() {});
      if (_controller.value.position == _controller.value.duration) {
        _controller.seekTo(Duration.zero).then((_) => _controller.pause());
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
    final seconds = _controller.value.position.inSeconds;
    final formattedTimestamp =
        '${seconds ~/ 60}:' + (seconds % 60).toString().padLeft(2, '0');
    return FutureBuilder<void>(
      future: _initializeVideoController,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MyLoader();
        }
        return GestureDetector(
          onTap: () => setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          }),
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              children: <Widget>[
                Hero(
                  tag: widget.media.url,
                  child: VideoPlayer(_controller),
                ),
                if (!_controller.value.isPlaying)
                  Container(color: Color.fromRGBO(0, 0, 0, 0.6)),
                if (_controller.value.isBuffering)
                  Center(child: MyLoader())
                else if (!_controller.value.isPlaying)
                  Center(child: Triangle()),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 40,
                  child: Row(
                    children: [
                      Expanded(
                        child: VideoProgressIndicator(
                          _controller,
                          padding: EdgeInsets.zero,
                          colors: VideoProgressColors(
                            playedColor: MyPalette.gold,
                          ),
                          allowScrubbing: true,
                        ),
                      ),
                      SizedBox(width: 14),
                      Text(
                        formattedTimestamp,
                        style: TextStyle(color: MyPalette.white),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
