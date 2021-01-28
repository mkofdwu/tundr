import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tundr/main.dart' as app;

Future<void> mockMethodChannels() async {
  // load sample image for testing
  final imageBytes = (await rootBundle.load('assets/test_images/Wall.jpg'))
      .buffer
      .asUint8List();
  final videoBytes = (await rootBundle.load('assets/test_images/Vid.mp4'))
      .buffer
      .asUint8List();
  final tempDir = await getTemporaryDirectory();
  final imageFile =
      await File('${tempDir.path}/wall.jpg').writeAsBytes(imageBytes);
  final videoFile =
      await File('${tempDir.path}/vid.mp4').writeAsBytes(videoBytes);

  const imagePickerChannel = MethodChannel('plugins.flutter.io/image_picker');
  imagePickerChannel.setMockMethodCallHandler((call) async {
    if (call.method == 'pickImage') {
      return imageFile.path;
    }
    if (call.method == 'pickVideo') {
      return videoFile.path;
    }
  });

  const imageCropperChannel = MethodChannel('plugins.hunghd.vn/image_cropper');
  imageCropperChannel.setMockMethodCallHandler((call) async {
    assert(
        call.method == 'cropImage', 'unexpected call method: ' + call.method);
    return imageFile.path;
  });
}

void main() {
  mockMethodChannels();
  app.main();
}
