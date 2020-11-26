import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tundr/models/media.dart';
import 'package:tundr/enums/media_type.dart';

class MediaPickerService {
  static Future<Media> pickMedia({
    @required MediaType type,
    @required ImageSource source,
    @required BuildContext context,
  }) async {
    File mediaFile;
    try {
      switch (type) {
        case MediaType.image:
          final imageFile = await ImagePicker().getImage(source: source);
          if (imageFile == null) return null;
          final croppedImage =
              await ImageCropper.cropImage(sourcePath: imageFile.path);
          if (croppedImage == null) return null;
          mediaFile = croppedImage;
          break;
        case MediaType.video:
          final videoFile = await ImagePicker().getVideo(source: source);
          if (videoFile == null) return null;
          mediaFile = File(videoFile.path);
          break;
        default:
          throw Exception('Invalid media type: $type');
      }
    } on PlatformException catch (error) {
      print(error.message);
      await showDialog(
        context: context,
        child: AlertDialog(
          content: Text(
              "We can't access your ${source == ImageSource.camera ? 'camera' : 'gallery'} without your permission"),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return null;
    }
    return Media(
      type: type,
      url: mediaFile.absolute.path,
      isLocalFile: true,
    );
  }
}
