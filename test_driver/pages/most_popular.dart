import 'package:test/test.dart';
import 'package:flutter_driver/flutter_driver.dart';

import '../utils/auth.dart';

void mostPopularTests() {
  FlutterDriver driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
    await loginWith(driver);
  });

  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  test('', () async {});
}
