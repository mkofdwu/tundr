import 'dart:async';
import "dart:html";
import "dart:convert";
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import "package:image_picker/image_picker.dart";
import "package:tundr/models/media.dart";
import 'package:tundr/pages/main/mediaconfirmationpage.dart';
import 'package:tundr/pages/takepicturepage.dart';
import 'package:tundr/pages/takevideopage.dart';
import 'package:tundr/utils/constants/enums/mediatype.dart';

class MediaPickerService {
  static int nImgWebCam = 0; // number of images taken with the webcam

  static Widget _whichPage(MediaType mediaType) {
    switch (mediaType) {
      case MediaType.image:
        return TakePicturePage();
      case MediaType.video:
        return TakeVideoPage();
      default:
        throw Exception("Invalid media type: $mediaType");
    }
  }

  static Future<Media> pickMedia({
    @required MediaType type,
    @required ImageSource source,
    @required BuildContext context,
  }) async {
    assert(kIsWeb);
    switch (source) {
      case ImageSource.camera:
        Media media;
        bool confirm = false;
        while (confirm == null || !confirm) {
          media = await Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  _whichPage(type),
              transitionsBuilder: (context, animation1, animation2, child) =>
                  child,
            ),
          );
          if (media == null) return null;
          confirm = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MediaConfirmationPage(media: media),
            ),
          );
        }
        return media;
      case ImageSource.gallery:
        final Completer<Blob> fileInputCompleter = Completer<Blob>();
        final InputElement uploadInput = FileUploadInputElement();
        uploadInput.click();
        uploadInput.onChange.listen((e) {
          final List<File> files = uploadInput.files;
          assert(files.length == 1);
          final File file = files.first;
          fileInputCompleter.complete(file);
        });
        final File file = await fileInputCompleter.future;

        final Completer<Media> completer = Completer<Media>();

        final FileReader reader = FileReader();
        reader.readAsDataUrl(file);
        reader.onLoad.listen((_) {
          // TODO: convert video blob to bytes
          Uint8List bytes;
          try {
            bytes = base64Decode((reader.result as String)
                .replaceFirst(RegExp(r"data:image/[^;]+;base64,"), ""));
          } on FormatException {
            showDialog(
              context: context,
              child: AlertDialog(
                title: Text("Invalid file type"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            );
            return;
          }
          completer.complete(Media.bytes(
            type: type,
            name: file.name,
            bytes: bytes,
          ));
        });
        reader.onError.listen((error) => completer.completeError(error));

        return completer.future;
      default:
        throw Exception("Invalid ImageSource: $source");
    }
  }
}
