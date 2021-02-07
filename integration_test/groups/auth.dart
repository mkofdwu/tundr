import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tundr/pages/welcome.dart';

import '../accounts.dart';
import '../flows/delete_account.dart';
import '../flows/registration.dart';
import '../flows/login.dart';
import '../utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Shows error with invalid credentials', (tester) async {
    await startApp(tester);

    expect(find.byType(WelcomePage), findsOneWidget);
    await tester.tap(find.byKey(ValueKey('loginBtn')));
    await tester.pumpAndSettle();

    // non existent accounts
    await testInvalidLoginWith(tester, 'nonexistentuser', '123456');
    await testInvalidLoginWith(tester, 'test', 'wrongpw');
    // badly formatted
    await testInvalidLoginWith(tester, '', '');
    await testInvalidLoginWith(tester, 'e\tu q\ntesting', '');
    await testInvalidLoginWith(tester, '', 'a \n\r\tpw');
  });

  testWidgets('Register and login tests', (tester) async {
    await startApp(tester);

    expect(find.byType(WelcomePage), findsOneWidget);
    await tester.tap(find.byKey(ValueKey('registerBtn')));
    await tester.pumpAndSettle();

    await invalidRegistration(tester);
    await registerWith(tester, Accounts.john);
    await logoutWith(tester);
    await loginWith(tester, account: Accounts.john);
  });

  // testWidgets(
  //     'Start conversation, send different types of messages, change wallpaper, check chat tile, ',
  //     (tester) async {
  //   await startApp(tester);
  //   // TODO fixme
  // });

  testWidgets('Delete account', (tester) async {
    await startApp(tester);
    await deleteAccount(tester);
  });
}
