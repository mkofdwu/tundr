import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
// import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/models/media.dart';
import 'package:tundr/enums/media_type.dart';
import 'package:tundr/utils/show_error_dialog.dart';

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
          // final croppedImage = await ImageCropper.cropImage(
          //   sourcePath: imageFile.path,
          //   androidUiSettings: AndroidUiSettings(
          //     activeControlsWidgetColor: MyPalette.gold,
          //   ),
          //   // TODO FIXME: iOS UI settings
          // );
          // if (croppedImage == null) return null;
          // mediaFile = croppedImage;
          mediaFile = File(imageFile.path);
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
      await showErrorDialog(
        context: context,
        title:
            "We can't access your ${source == ImageSource.camera ? 'camera' : 'gallery'}",
        content: error.message,
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
