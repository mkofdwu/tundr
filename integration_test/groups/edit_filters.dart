import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../utils/auth.dart';

void main() {
  setUpAll(() async {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('range slider filter', (tester) async {
    await tester.tap(find.byKey(ValueKey('meTab')));
    await tester.tap(find.text('Settings'));
    await tester.scrollUntilVisible(find.text('Filters'), 100);
    await tester.tap(find.text('Filters'));
    find.descendant(
      of: find.byType(Scaffold),
      matching: find.byType('GestureDetector'),
    );
    await tester.tap(find.text('Height'));
    await Future.delayed(Duration(seconds: 10));
  });

  testWidgets('', () async {});

  testWidgets('text field or other filter', () async {});
}
