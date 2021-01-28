import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tundr/pages/welcome.dart';

import '../utils/constants.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Delete account', (tester) async {
    await tester.tap(find.byKey(ValueKey('meTab')));
    await tester.tap(find.byKey(ValueKey('settingsBtn')));
    await tester.scrollUntilVisible(
        find.byKey(ValueKey('deleteAccountBtn')), 100);
    await tester.tap(find.byKey(ValueKey('deleteAccountBtn')));
    await tester.enterText(
        find.byKey(ValueKey('confirmPasswordField')), USER_PASSWORD);
    await tester.tap(find.byKey(ValueKey('confirmDeleteAccountBtn')));
    await tester.pumpAndSettle();
    expect(find.byType(WelcomePage), findsOneWidget);
  });
}
