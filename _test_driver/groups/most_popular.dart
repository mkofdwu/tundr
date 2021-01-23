import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../utils/auth.dart';

void main() {
  FlutterDriver driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
    await loginWith(driver);
  });

  tearDownAll(() async {
    if (driver != null) {
      await logoutWith(driver);
      await driver.close();
    }
  });

  test('Loads pictures within 7 seconds', () async {
    await driver.tap(find.byValueKey('mostPopularTab'));
    await driver.waitFor(find.byType('CachedNetworkImage'),
        timeout: Duration(seconds: 7));
  });
}
