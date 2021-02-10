import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tundr/pages/home.dart';
import 'package:tundr/pages/login.dart';
import 'package:tundr/pages/welcome.dart';

import '../accounts.dart';
import '../utils.dart';

Future<void> loginWith(
  WidgetTester tester, {
  @required Account account,
  bool expectHome = true,
}) async {
  expect(find.byType(LoginPage), findsOneWidget);
  await tester.enterText(
      find.byKey(ValueKey('usernameField')), account.username);
  await tester.enterText(
      find.byKey(ValueKey('passwordField')), account.password);
  await tester.tap(find.byKey(ValueKey('loginSubmitBtn')));
  await pump(tester, Duration(seconds: 1), 3);
  if (expectHome) {
    expect(find.byType(HomePage), findsOneWidget);
    Accounts.current = account;
  }
}

Future<void> testInvalidLoginWith(
    WidgetTester tester, String username, String password) async {
  await loginWith(
    tester,
    account: Account(username, password, exists: false),
    expectHome: false,
  );
  await tester.pump(Duration(seconds: 1));
  expect(find.byType(AlertDialog), findsOneWidget);
  await tester.tap(find.text('CLOSE'));
  await tester.pumpAndSettle();
}

Future<void> logoutWith(WidgetTester tester) async {
  expect(find.byType(HomePage), findsOneWidget);
  await tester.tap(find.byKey(ValueKey('meTab')));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Settings'));
  await tester.pumpAndSettle();
  await tester.scrollUntilVisible(find.text('Logout'), 100);
  await tester.tap(find.text('Logout'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pump(Duration(seconds: 1));
  await tester.pumpAndSettle();
  expect(find.byType(WelcomePage), findsOneWidget);
}

Future<void> switchAccount({Account to, WidgetTester tester}) async {
  await logoutWith(tester);
  await loginWith(tester, account: to);
}
