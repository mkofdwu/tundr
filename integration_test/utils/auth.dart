import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tundr/pages/home.dart';
import 'package:tundr/pages/welcome.dart';

Future<void> loginWith(
  WidgetTester tester, {
  String username = 'test',
  String password = '123456',
  bool waitForHome = true,
}) async {
  await tester.tap(find.byKey(ValueKey('loginBtn')));
  await tester.enterText(find.byKey(ValueKey('usernameField')), username);
  await tester.enterText(find.byKey(ValueKey('passwordField')), password);
  await tester.tap(find.byKey(ValueKey('loginSubmitBtn')));
  if (waitForHome) expect(find.byType(HomePage), findsOneWidget);
}

Future<void> logoutWith(WidgetTester tester) async {
  await tester.tap(find.byKey(ValueKey('meTab')));
  await tester.tap(find.text('Settings'));
  await tester.scrollUntilVisible(find.text('Logout'), 100);
  await tester.tap(find.text('Logout'));
  await tester.tap(find.text('OK'));
  expect(find.byType(WelcomePage), findsOneWidget);
}
