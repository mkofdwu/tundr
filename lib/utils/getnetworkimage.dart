import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

ImageProvider getNetworkImageProvider(String url) {
  return kIsWeb ? NetworkImage(url) : CachedNetworkImageProvider(url);
}

Widget getNetworkImage(
  String url, {
  double width,
  double height,
  BoxFit fit = BoxFit.cover,
}) {
  if (url == null || url.isEmpty) return SizedBox.shrink();
  return kIsWeb
      ? Image.network(
          url,
          width: width,
          height: height,
          fit: fit,
        )
      : CachedNetworkImage(
          imageUrl: url,
          width: width,
          height: height,
          fit: fit,
        );
}
