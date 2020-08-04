import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/widgets.dart";
import 'package:photo_view/photo_view.dart';
import 'package:tundr/models/media.dart';
import 'package:tundr/utils/constants/enums/mediatype.dart';
import 'package:tundr/widgets/media/simplevideoplayer.dart';

class MediaViewer extends StatelessWidget {
  final Media media;

  MediaViewer({Key key, @required this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (media.type) {
      case MediaType.image:
        return media.isInBytes
            ? Hero(
                tag: media.name,
                child: PhotoView(
                  minScale: PhotoViewComputedScale.contained,
                  imageProvider: MemoryImage(media.bytes),
                ),
              )
            : Hero(
                tag: media.url,
                child: PhotoView(
                  minScale: PhotoViewComputedScale.contained,
                  imageProvider: media.isLocalFile
                      ? FileImage(File(media.url))
                      : CachedNetworkImageProvider(media.url),
                ),
              );
      case MediaType.video:
        return SimpleVideoPlayer(media: media);
      default:
        throw Exception("Invalid media type: ${media.type}");
    }
  }
}
