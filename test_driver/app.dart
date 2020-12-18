import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tundr/main.dart' as app;

Future<void> mockMethodChannels() async {
  // load sample image for testing
  final bytes = (await rootBundle.load('assets/test_images/Wall.jpg'))
      .buffer
      .asUint8List();
  final tempDir = await getTemporaryDirectory();
  final imageFile = await File('${tempDir.path}/wall.jpg').writeAsBytes(bytes);

  const imagePickerChannel = MethodChannel('plugins.flutter.io/image_picker');
  imagePickerChannel.setMockMethodCallHandler((call) async {
    if (call.method == 'pickImage') {
      return imageFile.path;
    }
    if (call.method == 'pickVideo') {}
  });

  const imageCropperChannel = MethodChannel('plugins.hunghd.vn/image_cropper');
  imageCropperChannel.setMockMethodCallHandler((call) async {
    assert(
        call.method == 'cropImage', 'unexpected call method: ' + call.method);
    return imageFile.path;
  });
}

void main() {
  enableFlutterDriverExtension();
  mockMethodChannels();
  app.main();
}
