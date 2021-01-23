import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../utils/constants.dart';

void main() {
  FlutterDriver driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() {
    if (driver != null) driver.close();
  });

  test('Delete account', () async {
    await driver.tap(find.byValueKey('meTab'));
    await driver.tap(find.byValueKey('settingsBtn'));
    await driver.scrollIntoView(find.byValueKey('deleteAccountBtn'));
    await driver.tap(find.byValueKey('deleteAccountBtn'));
    await driver.tap(find.byValueKey('confirmPasswordField'));
    await driver.enterText(USER_PASSWORD);
    await driver.tap(find.byValueKey('confirmDeleteAccountBtn'));
    await driver.waitFor(find.byType('WelcomePage'));
  });
}
