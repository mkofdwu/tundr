import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/auth.dart';
import '../utils/processes.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> invalidLoginWith(
      WidgetTester tester, String username, String password) async {
    await loginWith(
      tester,
      username: username,
      password: password,
      waitForHome: false,
    );
    await tester.waitFor(find.byType(AlertDialog));
    await tester.tap(find.text('CLOSE'));
    await back();
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

  testWidgets('Logs in with correct credentials', (tester) async {
    await loginWith(tester);
  });
}
