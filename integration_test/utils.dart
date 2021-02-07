import 'package:flutter_test/flutter_test.dart';
import 'package:tundr/main.dart' as app;

Future<void> startApp(WidgetTester tester) async {
  await app.main();
  await tester.pumpAndSettle();
}

// Future<void> back(WidgetTester tester) async {
//   await Process.run(
//     '/home/leejiajie/Android/Sdk/platform-tools/adb',
//     <String>['shell', 'input', 'keyevent', 'KEYCODE_BACK'],
//     runInShell: true,
//   );
//   await tester.pump(Duration(seconds: 1));
//   await tester.pumpAndSettle();
// }

Future<void> pump(WidgetTester tester, Duration interval, int times) async {
  for (var i = 0; i < times; ++i) {
    await tester.pump(interval);
  }
}
