import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tundr/main.dart' as app;

import '../utils/auth.dart';
// import '../utils/processes.dart';

void main() {
  setUpAll(() async {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('Logs in with correct credentials', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    await loginWith(tester);
    await tester.pumpAndSettle();
  });

  testWidgets('Logs out correctly', (tester) async {
    await logoutWith(tester);
  });

  Future<void> invalidLoginWith(
      WidgetTester tester, String username, String password) async {
    await loginWith(
      tester,
      username: username,
      password: password,
      waitForHome: false,
    );
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(find.text('CLOSE'));
    await tester.pageBack(); // await back();
  }

  testWidgets('Shows error with incorrect credentials', (tester) async {
    await invalidLoginWith(tester, 'nonexistentuser', '123456');
    await invalidLoginWith(tester, 'test', 'wrongpw');
  });

  testWidgets('Shows error with badly formatted credentials', (tester) async {
    await invalidLoginWith(tester, '', '');
    await invalidLoginWith(tester, 'e\tu q\ntesting', '');
    await invalidLoginWith(tester, '', 'a \n\r\tpw');
  });
}
