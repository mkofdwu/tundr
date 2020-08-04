import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

Widget getNetworkImage(
  String url, {
  double width,
  double height,
  BoxFit fit = BoxFit.cover,
}) {
  if (url == null || url.isEmpty) return SizedBox.shrink();
  return CachedNetworkImage(
    imageUrl: url,
    width: width,
    height: height,
    fit: fit,
  );
}
