import 'dart:io';

import 'package:flutter/material.dart';
import "package:flutter/widgets.dart";
import 'package:tundr/models/media.dart';
import 'package:tundr/enums/mediatype.dart';
import 'package:tundr/utils/get-network-image.dart';
import 'package:tundr/widgets/media/video-thumbnail.dart';

class MediaThumbnail extends StatelessWidget {
  final Media media;

  MediaThumbnail(this.media, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (media.type) {
      case MediaType.image:
        return Hero(
          tag: media.url,
          child: media.isLocalFile
              ? Image.file(
                  File(media.url),
                  fit: BoxFit.cover,
                )
              : getNetworkImage(media.url),
        );
      case MediaType.video:
        return VideoThumbnail(media: media);
      default:
        throw Exception("Invalid media type: ${media.type}");
    }
  }
}
