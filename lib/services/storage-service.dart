import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import "package:path_provider/path_provider.dart";
import "package:flutter_image_compress/flutter_image_compress.dart";
import "package:flutter_video_compress/flutter_video_compress.dart";
import 'package:tundr/models/media.dart';
import 'package:tundr/constants/enums/mediatype.dart';
import 'package:tundr/constants/values.dart';
import 'package:uuid/uuid.dart';
import "package:tundr/constants/firebaseref.dart";
import "package:http/http.dart";

class FileTooLargeError implements Exception {}

class StorageService {
  static Future<String> uploadMedia({
    @required String uid,
    @required Media media,
    String oldUrl,
    String prefix = "",
  }) async {
    // FIXME: FUTURE: IMPROVE AND CLEAN UP
    // assert(media.isLocalFile == null ? media.isInBytes : media.isLocalFile);

    String id;
    String storagePath;

    if (oldUrl == null) {
      id = Uuid().v4();
    } else {
      final RegExp exp = RegExp(prefix + r"_(.*?).jpg");
      RegExpMatch match = exp.firstMatch(oldUrl);
      if (match != null) id = match[1];
    }
    if (media.isLocalFile) {
      File compressedFile;
      switch (media.type) {
        case MediaType.image:
          final Directory tempDir = await getTemporaryDirectory();
          compressedFile = await FlutterImageCompress.compressAndGetFile(
            media.url,
            "${tempDir.path}/$id.jpg",
            quality: 70,
          );
          storagePath = "images/$uid/${prefix}_$id"; // FUTURE: improve this
          break;
        case MediaType.video:
          compressedFile = File((await FlutterVideoCompress().compressVideo(
                  media.url,
                  quality: VideoQuality.MediumQuality))
              .path);
          storagePath = "videos/$uid/${prefix}_$id";
          break;
        default:
          throw Exception("Invalid media type: ${media.type}");
      }

      final StorageUploadTask uploadTask =
          storageRef.child(storagePath).putFile(compressedFile);
      final StorageTaskSnapshot storageTaskSnapshot =
          await uploadTask.onComplete;
      return (await storageTaskSnapshot.ref.getDownloadURL()) as String;
    } else {
      final httpClient = Client();
      Uint8List data =
          (await httpClient.get(media.url)).bodyBytes; // TODO: FIXME:
      if (media.type == MediaType.image &&
              data.elementSizeInBytes > maxImageSizeInBytes ||
          media.type == MediaType.video &&
              data.elementSizeInBytes > maxVideoSizeInBytes) {
        throw FileTooLargeError();
      }

      final StorageUploadTask uploadTask =
          storageRef.child(storagePath).putData(data);
      final StorageTaskSnapshot storageTaskSnapshot =
          await uploadTask.onComplete;
      return (await storageTaskSnapshot.ref.getDownloadURL()) as String;
    }
  }

  static Future<void> deleteMedia(String url) async =>
      (await FirebaseStorage.instance.getReferenceFromUrl(url)).delete();
}
