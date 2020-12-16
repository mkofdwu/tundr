import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../utils/auth.dart';
import '../utils/processes.dart';

void loginTests() {
  FlutterDriver driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    if (driver != null) await driver.close();
  });

  test('Logs in with correct credentials', () async {
    await loginWith(driver);
  });

  test('Logs out correctly', () async {
    await logoutWith(driver);
  });

  test('Shows error with incorrect credentials', () async {
    await loginWith(
      driver,
      username: 'nonexistentuser',
      password: '123456',
      waitForHome: false,
    );
    await driver.waitFor(find.byType('AlertDialog'));
    await driver.tap(find.text('CLOSE'));
    await back();
    await loginWith(
      driver,
      username: 'test',
      password: 'wrongpw',
      waitForHome: false,
    );
    await driver.waitFor(find.byType('AlertDialog'));
    await driver.tap(find.text('CLOSE'));
    await back();
  });
}
