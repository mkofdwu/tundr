import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:tundr/main.dart' as app;

import '../../utils/auth.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Start conversation with unknown user', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    await loginWith(tester);
  });

  testWidgets(
      'Starting a conversation without sending a message does not create chat',
      (tester) async {});

  testWidgets('Send message', (tester) async {});

  testWidgets('Block user and delete chat does exactly that', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    await loginWith(tester);
  });

  testWidgets('Mesage pagination', (tester) async {});
}
