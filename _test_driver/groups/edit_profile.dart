import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  FlutterDriver driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
    // should be at home page
    await driver.waitFor(find.byType('HomePage'));
    await driver.tap(find.byValueKey('meTab'));
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

  test('Add extra media', () async {
    await driver.tap(find.byValueKey('extraMediaEditTile0'));
    await driver.tap(find.text('Image'));
    await driver.tap(find.text('Camera'));
    await driver.tap(find.byValueKey('extraMediaEditTile5'));
    await driver.tap(find.text('Video'));
    await driver.tap(find.text('Camera'));
  });

  test('Replace extra media', () async {
    await driver.tap(find.byValueKey('extraMediaEditTile0'));
    await driver.waitFor(find.byType('EditExtraMediaPage'));
    await driver.tap(find.byValueKey('menu'));
    await driver.tap(find.text('Replace with video')); // video
    await driver.tap(find.byType('MyBackButton'));
  });

  test('Delete extra media', () async {
    await driver.tap(find.byValueKey('extraMediaEditTile0'));
    await driver.waitFor(find.byType('EditExtraMediaPage'));
    await driver.tap(find.byValueKey('menu'));
    await driver.tap(find.byValueKey('deleteBtn'));
    await driver.waitFor(find.byType('EditProfilePage'));
  });

  test('Change all personal info', () async {
    await driver.scrollIntoView(find.byType('PersonalInfoList'));
    await driver.tap(find.byValueKey('School'));
    await driver.tap(find.byValueKey('Height'));
  });

  test('Edit interests (includes interestbrowser)', () async {
    await driver.scrollIntoView(find.byValueKey('editInterestsBtn'));
    await driver.tap(find.byValueKey('editInterestsBtn'));
    // at interestseditpage (browser)
    await driver.tap(find.text('Animals'));
    await driver.tap(find.text('Bird Watching'));
    // TODO
  });

  test('Preview profile', () async {
    await driver.tap(find.byValueKey('previewProfileBtn'));
    await driver.waitFor(find.byType('MainProfilePage'));
    await driver.waitFor(find.text('test, 15'));
    await driver.waitForAbsent(find.byValueKey('chatWithUserBtn'));
    await driver.tap(find.byType('MyBackButton'));
  });
}
