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
    if (tester != null) {
      await logoutWith(tester);
      await tester.close();
    }
  });

  testWidgets('Loads pictures within 7 seconds', () async {
    await tester.tap(find.byKey(ValueKey('mostPopularTab')));
    await tester.waitFor(find.byType('CachedNetworkImage'),
        timeout: Duration(seconds: 7));
  });
}
