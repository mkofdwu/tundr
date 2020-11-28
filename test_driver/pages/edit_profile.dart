import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void editProfileTests() {
  FlutterDriver driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
    // should be at home page
    await driver.waitFor(find.byType('HomePage'));
    await driver.tap(find.byValueKey('tab0'));
    await driver.tap(find.text('Profile'));
    await driver.waitFor(find.byType('OwnProfilePage'));
  });

  tearDownAll(() async {
    if (driver != null) await driver.close();
  });

  test('Change name', () async {});

  test('Edit interests', () async {});

  test('Add extra media', () async {});

  test('Delete extra media', () async {});

  test('Replace extra media', () async {});

  // TODO: restart app to test?
}
