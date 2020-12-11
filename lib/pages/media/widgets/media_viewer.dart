import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tundr/models/media.dart';
import 'package:tundr/enums/media_type.dart';
import 'package:tundr/pages/media/widgets/simple_video_player.dart';

class MediaViewer extends StatelessWidget {
  final Media media;

  MediaViewer({Key key, @required this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (media.type) {
      case MediaType.image:
        return Hero(
          tag: media.url,
          child: PhotoView(
            backgroundDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            minScale: PhotoViewComputedScale.contained,
            imageProvider: media.isLocalFile
                ? FileImage(File(media.url))
                : CachedNetworkImageProvider(media.url),
          ),
        );
      case MediaType.video:
        return Center(child: SimpleVideoPlayer(media: media));
      default:
        throw Exception('Invalid media type: ${media.type}');
    }
  }
}
