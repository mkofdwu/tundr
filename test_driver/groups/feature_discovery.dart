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

  test('all features', () async {
    await loginWith(driver);
    await logoutWith(driver);
  });

  test('app tour resets all features again', () async {});
}
