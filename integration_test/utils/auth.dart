import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tundr/main.dart' as app;
import 'package:tundr/pages/home.dart';
import 'package:tundr/pages/welcome.dart';

import 'constants.dart';

Future<void> startApp(
  WidgetTester tester, {
  bool expectHome = true,
}) async {
  app.main();
  await tester.pumpAndSettle();
  if (expectHome) expect(find.byType(HomePage), findsOneWidget);
}

Future<void> loginWith(
  WidgetTester tester, {
  String username = USER_USERNAME,
  String password = USER_PASSWORD,
  bool expectHome = true,
}) async {
  await tester.tap(find.byKey(ValueKey('loginBtn')));
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(ValueKey('usernameField')), username);
  await tester.enterText(find.byKey(ValueKey('passwordField')), password);
  await tester.tap(find.byKey(ValueKey('loginSubmitBtn')));
  await tester.pumpAndSettle();
  await tester.pump(Duration(seconds: 4));
  if (expectHome) expect(find.byType(HomePage), findsOneWidget);
}

Future<void> logoutWith(WidgetTester tester) async {
  await tester.tap(find.byKey(ValueKey('meTab')));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Settings'));
  await tester.pumpAndSettle();
  await tester.scrollUntilVisible(find.text('Logout'), 100);
  await tester.tap(find.text('Logout'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pump(Duration(seconds: 2));
  expect(find.byType(WelcomePage), findsOneWidget);
}
