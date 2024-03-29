import 'package:tundr/enums/media_type.dart';

class Media {
  MediaType type;
  String url;
  bool isLocalFile;

  Media({this.type, this.url, this.isLocalFile});

  factory Media.fromMap(Map map) {
    if (map['type'] == null) return null;
    return Media(
      type: MediaType.values[map['type']],
      url: map['url'],
      isLocalFile: false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': MediaType.values.indexOf(type),
      'url': url,
    };
  }

  @override
  String toString() =>
      'Media(type: $type, url: $url, isLocalFile: $isLocalFile)';
}
