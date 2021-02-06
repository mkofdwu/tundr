import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tundr/main.dart' as app;

Future<void> startApp(WidgetTester tester) async {
  await app.main();
  await tester.pumpAndSettle();
}

Future<void> back() => Process.run(
      '/home/leejiajie/Android/Sdk/platform-tools/adb',
      <String>['shell', 'input', 'keyevent', 'KEYCODE_BACK'],
      runInShell: true,
    );
