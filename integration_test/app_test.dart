import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';

import 'groups/auth.dart' as auth;

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
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  mockMethodChannels();
  group('Authentication flows', auth.main);
  // group('Login', login.main);
  // group('Swiping page', swiping.main);
  // group('Most popular page', most_popular.main);
  // group('Search for users', search_users.main);
  // group('Edit profile', edit_profile.main);
  // group('Edit filters', edit_filters.main);
  // group('Chats', chat.main);
}
