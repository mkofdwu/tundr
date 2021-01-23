import 'dart:io';

Future<void> back() => Process.run(
      '/home/leejiajie/Android/Sdk/platform-tools/adb',
      <String>['shell', 'input', 'keyevent', 'KEYCODE_BACK'],
      runInShell: true,
    );
