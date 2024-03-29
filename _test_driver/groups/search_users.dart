import 'package:test/test.dart';
import 'package:flutter_driver/flutter_driver.dart';

import '../utils/auth.dart';

void main() {
  FlutterDriver driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
    await loginWith(driver);
  });

  tearDownAll(() async {
    await logoutWith(driver);
    if (driver != null) {
      await driver.close();
    }
  });

  test('Search for users whose useranme start with test', () async {
    await driver.tap(find.byValueKey('searchTab'));
    await driver.tap(find.byValueKey('searchTextField'));
    await driver.enterText('test');
    await driver.waitForAbsent(
        find.text('test')); // don't show the currently logged in user
    await driver.waitFor(find.text('test2'));
    await driver.waitFor(find.text('tester'));
  });
}
