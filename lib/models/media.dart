import 'package:tundr/utils/constants/enums/mediatype.dart';

class Media {
  // FUTURE: FIXME: use MediaSource instead of isInBytes and isLocalFile
  MediaType type;
  String url;
  bool isLocalFile;

  Media({this.type, this.url, this.isLocalFile});

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
  String toString() => "media, name / url: $url";
}
