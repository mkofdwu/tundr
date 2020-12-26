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
      await tester.close();
    }
  });

  testWidgets('Renders first suggestion correctly', () {});

  testWidgets('Cannot undo first suggestion', () async {});

  testWidgets(
      'Swipe right on liked suggestion shows its a match page', () async {});

  testWidgets(
      'Swipe right on generated suggestion sends suggestion', () async {});

  testWidgets('Can undo swipe on previous suggestion', () async {});
}
