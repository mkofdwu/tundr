import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/auth.dart';
import '../utils/processes.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Future<void> invalidLoginWith(
  //     WidgetTester tester, String username, String password) async {
  //   await loginWith(
  //     tester,
  //     username: username,
  //     password: password,
  //     expectHome: false,
  //   );
  //   expect(find.byType(AlertDialog), findsOneWidget);
  //   await tester.tap(find.text('CLOSE'));
  //   await back();
  //   await tester.pumpAndSettle();
  // }

  // testWidgets('Shows error with incorrect credentials', (tester) async {
  //   await startApp(tester, expectHome: false);
  //   await invalidLoginWith(tester, 'nonexistentuser', '123456');
  //   await invalidLoginWith(tester, 'test', 'wrongpw');
  // });

  // testWidgets('Shows error with badly formatted credentials', (tester) async {
  //   await startApp(tester, expectHome: false);
  //   await invalidLoginWith(tester, '', '');
  //   await invalidLoginWith(tester, 'e\tu q\ntesting', '');
  //   await invalidLoginWith(tester, '', 'a \n\r\tpw');
  // });

  testWidgets('Logs in with correct credentials', (tester) async {
    await startApp(tester, expectHome: false);
    await loginWith(tester);
  });
}
