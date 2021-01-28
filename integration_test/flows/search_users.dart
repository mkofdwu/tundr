import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../utils/auth.dart';
import 'package:tundr/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Search for users whose useranme start with test',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();
    await loginWith(tester);
    await tester.tap(find.byKey(ValueKey('searchTab')));
    await tester.enterText(find.byKey(ValueKey('searchTextField')), 'test');
    // don't show the currently logged in user
    expect(find.text('test'), findsNothing);
    await tester.pumpAndSettle();
    expect(find.text('test2'), findsOneWidget);
    expect(find.text('tester'), findsOneWidget);
  });
}
