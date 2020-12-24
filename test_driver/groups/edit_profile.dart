import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../utils/auth.dart';

void main() {
  FlutterDriver driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
    // should be at home page
    await loginWith(driver);
    await driver.waitFor(find.byType('HomePage'));
    await driver.tap(find.byValueKey('dashboardTab'));
    await driver.tap(find.text('Profile'));
    await driver.waitFor(find.byType('EditProfilePage'));
  });

  tearDownAll(() async {
    if (driver != null) await driver.close();
  });

  test('Change about', () async {
    await driver.tap(find.byValueKey('editAboutMeBtn'));
    await driver.enterText('This is my about (edited)');
    await driver.tap(find.byValueKey('updateAboutMeBtn'));
    final text = await driver.getText(find.byValueKey('aboutMeField'));
    expect(text, 'This is my about (edited)');
    // reset
    await driver.tap(find.byValueKey('aboutMeField'));
    await driver.enterText('This is my about');
    await driver.tap(find.byValueKey('updateAboutMeBtn'));
  });

  test('Add extra media', () async {});

  test('Delete extra media', () async {});

  test('Replace extra media', () async {});

  test('Change all personal info', () async {});

  test('Click personal info but dont change anything', () async {});

  test('Edit interests', () async {
    await driver.scrollUntilVisible(
        find.byType('EditProfilePage'), find.byValueKey('editInterestsBtn'));
    await driver.tap(find.byValueKey('editInterestsBtn'));
    // at interestseditpage (browser)
    await driver.tap(find.text('Animals'));
    await driver.tap(find.text('Bird Watching'));
    // TODO
  });

  test('Preview profile', () async {});
}
