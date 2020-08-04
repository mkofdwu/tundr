import 'dart:typed_data';

import 'package:tundr/utils/constants/enums/mediatype.dart';

class Media {
  // FUTURE: FIXME: use MediaSource instead of isInBytes and isLocalFile
  MediaType type;
  String url;
  bool isLocalFile;

  // for web
  String name;
  Uint8List bytes;
  bool isInBytes;

  Media({this.type, this.url, this.isLocalFile}) {
    isInBytes = false;
  }
  Media.bytes({this.type, this.name, this.bytes}) {
    isInBytes = true;
  }

  factory Media.fromMap(Map map) {
    if (map["type"] == null) return null;
    return Media(
      type: MediaType.values.elementAt(map["type"]),
      url: map["url"],
      isLocalFile: false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "type": MediaType.values.indexOf(type),
      "url": url,
    };
  }

  @override
  String toString() => "media, name / url: ${isInBytes ? name : url}";
}
