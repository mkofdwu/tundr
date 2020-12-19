import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  FlutterDriver driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
    // should be at home page
    await driver.waitFor(find.byType('HomePage'));
    await driver.tap(find.byValueKey('dashboardTab'));
    await driver.tap(find.text('Profile'));
    await driver.waitFor(find.byType('OwnProfilePage'));
  });

  tearDownAll(() async {
    if (driver != null) await driver.close();
  });

  test('Change about', () async {
    await driver.tap(find.byValueKey('editAboutMeBtn'));
    await driver.enterText('(updated)\nTesting');
    await driver.tap(find.byValueKey('updateAboutMeBtn'));
    await driver.getText(find.byValueKey('aboutMeField'));
  });

  test('Edit interests', () async {});

  test('Add extra media', () async {});

  test('Delete extra media', () async {});

  test('Replace extra media', () async {});
}
