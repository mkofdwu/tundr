import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../utils/auth.dart';

void main() {
  FlutterDriver tester;

  setUpAll(() async {
    tester = await FlutterDriver.connect();
    await loginWith(tester);
  });

  tearDownAll(() async {
    await logoutWith(tester);
    if (tester != null) {
      await tester.close();
    }
  });

  testWidgets('Search for users whose useranme start with test', () async {
    await tester.tap(find.byKey(ValueKey('searchTab')));
    await tester.tap(find.byKey(ValueKey('searchTextField')));
    await tester.enterText('test');
    await tester.waitForAbsent(
        find.text('test')); // don't show the currently logged in user
    await tester.waitFor(find.text('test2'));
    await tester.waitFor(find.text('tester'));
  });
}
