import 'package:test/test.dart';
import 'package:flutter_driver/flutter_driver.dart';

import 'utils/login.dart';

void swipingPageTests() {
  final card = find.byValueKey('card');

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

  test('Renders first suggestion correctly', () {});

  test('Cannot undo first suggestion', () async {});

  test('Swipe right on liked suggestion shows its a match page', () async {});

  test('Swipe right on generated suggestion sends suggestion', () async {});

  test('Can undo swipe on previous suggestion', () async {});
}
