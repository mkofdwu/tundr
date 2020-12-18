import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../utils/auth.dart';
import '../utils/processes.dart';

void main() {
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

  Future<void> invalidLoginWith(
      FlutterDriver driver, String username, String password) async {
    await loginWith(
      driver,
      username: username,
      password: password,
      waitForHome: false,
    );
    await driver.waitFor(find.byType('AlertDialog'));
    await driver.tap(find.text('CLOSE'));
    await back();
  }

  test('Shows error with incorrect credentials', () async {
    await invalidLoginWith(driver, 'nonexistentuser', '123456');
    await invalidLoginWith(driver, 'test', 'wrongpw');
  });

  test('Shows error with badly formatted credentials', () async {
    await invalidLoginWith(driver, '', '');
    await invalidLoginWith(driver, 'e\tu q\ntesting', '');
    await invalidLoginWith(driver, '', 'a \n\r\tpw');
  });
}
