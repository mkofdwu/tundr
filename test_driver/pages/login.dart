import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../utils/auth.dart';

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
}
