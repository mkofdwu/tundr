import 'package:flutter/material.dart';
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
      await driver.close();
    }
  });

  test('range slider filter', () async {
    await driver.tap(find.byValueKey('meTab'));
    await driver.tap(find.text('Settings'));
    await driver.scrollIntoView(find.text('Filters'));
    await driver.tap(find.text('Filters'));
    find.descendant(
      of: find.byType('Scaffold'),
      matching: find.byType('GestureDetector'),
    );
    await driver.tap(find.text('Height'));
    await Future.delayed(Duration(seconds: 10));
  });

  test('', () async {});

  test('text field or other filter', () async {});
}
