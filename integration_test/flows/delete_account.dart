import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tundr/pages/home.dart';
import 'package:tundr/pages/welcome.dart';

import '../accounts.dart';

void deleteAccount(WidgetTester tester) async {
  expect(find.byType(HomePage), findsOneWidget);
  for (final featureKey in [
    'suggestionCardFeature',
    'searchFeature',
    'mostPopularFeature'
  ]) {
    await tester.tap(find.byKey(ValueKey(featureKey)));
    await tester.pump(Duration(seconds: 1));
  }
  await tester.tap(find.byKey(ValueKey('meTab')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(ValueKey('settingsBtn')));
  await tester.pumpAndSettle();
  await tester.scrollUntilVisible(
      find.byKey(ValueKey('deleteAccountBtn')), 100);
  await tester.tap(find.byKey(ValueKey('deleteAccountBtn')));
  await tester.pumpAndSettle();
  await tester.enterText(
      find.byKey(ValueKey('confirmPasswordField')), Accounts.current.password);
  await tester.tap(find.byKey(ValueKey('confirmDeleteAccountBtn')));
  await tester.pumpAndSettle();
  expect(find.byType(WelcomePage), findsOneWidget);

  Accounts.current.exists = false;
  Accounts.current = null;
}
