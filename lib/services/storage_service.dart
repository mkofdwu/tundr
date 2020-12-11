import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:tundr/models/media.dart';
import 'package:tundr/enums/media_type.dart';
import 'package:tundr/constants/numbers.dart';
import 'package:uuid/uuid.dart';
import 'package:tundr/constants/firebase_ref.dart';
import 'package:http/http.dart';
import 'package:video_compress/video_compress.dart';

class FileTooLargeError implements Exception {}

class StorageService {
  static Future<String> uploadMedia({
    @required String uid,
    @required Media media,
    String oldUrl,
    String prefix = '',
  }) async {
    // FIXME: FUTURE: IMPROVE AND CLEAN UP
    // assert(media.url == null ? media.isInBytes : media.isLocalFile);
    assert(uid != null);

    String id;
    String storagePath;

    if (oldUrl == null) {
      id = Uuid().v4();
    } else {
      final exp = RegExp(prefix + r'_(.*?).jpg');
      final match = exp.firstMatch(oldUrl);
      if (match != null) id = match[1];
    }
    if (media.isLocalFile) {
      File compressedFile;
      switch (media.type) {
        case MediaType.image:
          final tempDir = await getTemporaryDirectory();
          compressedFile = await FlutterImageCompress.compressAndGetFile(
            media.url,
            '${tempDir.path}/$id.jpg',
            quality: 70,
          );
          storagePath = 'images/$uid/${prefix}_$id'; // FUTURE: improve this
          break;
        case MediaType.video:
          compressedFile = File((await VideoCompress.compressVideo(
            media.url,
            quality: VideoQuality.MediumQuality,
          ))
              .path);
          storagePath = 'videos/$uid/${prefix}_$id';
          break;
        default:
          throw Exception('Invalid media type: ${media.type}');
      }

      final storageTaskSnapshot =
          await storageRef.child(storagePath).putFile(compressedFile);
      return await storageTaskSnapshot.ref.getDownloadURL();
    } else {
      throw 'Not supposed to upload files from the internet';
      // final httpClient = Client();
      // final data = (await httpClient.get(media.url)).bodyBytes;
      // if (media.type == MediaType.image &&
      //         data.elementSizeInBytes > maxImageSizeInBytes ||
      //     media.type == MediaType.video &&
      //         data.elementSizeInBytes > maxVideoSizeInBytes) {
      //   throw FileTooLargeError();
      // }

      // final storageTaskSnapshot =
      //     await storageRef.child(storagePath).putData(data);
      // return await storageTaskSnapshot.ref.getDownloadURL();
    }
  }

  static Future<void> deleteMedia(String url) async =>
      (await FirebaseStorage.instance.refFromURL(url)).delete();
}
