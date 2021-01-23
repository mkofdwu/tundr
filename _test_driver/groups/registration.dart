import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../utils/processes.dart';
import '../utils/constants.dart';

void main() {
  FlutterDriver driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() {
    if (driver != null) driver.close();
  });

  Future<void> registerWith(
    FlutterDriver driver,
    String username,
    String password,
    String confirmPassword,
  ) async {
    await driver.tap(find.byValueKey('registerBtn'));
    await driver.tap(find.byValueKey('usernameField'));
    await driver.enterText(username);
    await driver.tap(find.byValueKey('passwordField'));
    await driver.enterText(password);
    await driver.tap(find.byValueKey('confirmPasswordField'));
    await driver.enterText(confirmPassword);
    await driver.tap(find.text('Setup'));
  }

  test('Shows error with invalid input', () async {
    // existing username
    await registerWith(driver, 'test', 'password', 'password');
    await driver.waitFor(find.byType('AlertDialog'));
    await driver.tap(find.text('CLOSE'));
    await back();
    // not matching passwords
    await registerWith(driver, 'username9978', 'password', 'password1');
    await driver.waitFor(find.byType('AlertDialog'));
    await driver.tap(find.text('CLOSE'));
    await back();
    // invalid username
    await registerWith(driver, ' usernam\ne9978\r \t', 'password', 'password');
    await driver.waitFor(find.byType('AlertDialog'));
    await driver.tap(find.text('CLOSE'));
    await back();
    // nothing
    await registerWith(driver, '', '', '');
    await driver.waitFor(find.byType('AlertDialog'));
    await driver.tap(find.text('CLOSE'));
    await back();
  });

  test('Registration flow works correctly', () async {
    await registerWith(driver, USER_USERNAME, USER_PASSWORD, USER_PASSWORD);

    await driver.runUnsynchronized(() async {
      await driver.waitFor(find.byType('SetupNamePage'));
      await driver.tap(find.byValueKey('nameField'));
      await driver.enterText(USER_USERNAME);
      await driver.tap(find.byType('ScrollDownArrow'));

      await driver.waitFor(find.byType('SetupBirthdayPage'));
      await driver.tap(find.byValueKey('digit1'));
      for (final digitChar in '20102005'.split('')) {
        await driver.enterText(digitChar);
        await Future.delayed(Duration(milliseconds: 100));
      }
      await driver.tap(find.byType('ScrollDownArrow'));

      await driver.waitFor(find.byType('SetupGenderPage'));
      await driver.tap(find.text('Male'));
      await driver.tap(find.byType('ScrollDownArrow'));

      await driver.waitFor(find.byType('SetupProfilePicPage'));
      await driver.tap(find.text('Camera'));
      // image will be taken automatically
      await driver.tap(find.byType('ScrollDownArrow'));

      await driver.waitFor(find.byType('SetupInterestsPage'));
      // await driver.tap(find.text('Custom'));
      // await driver.tap(find.text('Add new'));
      // await driver.enterText('my custom interest\n');
      // await driver.tap(find.text('Animals'));
      await driver.tap(find.text('Birds'));
      await driver.tap(find.text('Cats'));
      await driver.tap(find.text('Dogs'));
      await driver.tap(find.text('Outdoors'));
      await driver.tap(find.text('Hiking'));
      await driver.tap(find.text('Camping'));
      await driver.tap(find.text('Climbing'));
      await driver.tap(find.text('Environment'));
      await driver.tap(find.text('Nature'));
      await driver.tap(find.byType('TextField')); // search field
      await driver.enterText('comput');
      await driver.tap(find.text('Computers'));
      await driver.tap(find.text('Computer Graphics'));
      await driver.tap(find.text('Computer Science'));
      await driver.tap(find.text('Computer Security'));
      await driver.tap(find.text('Computer Hardware'));
      await driver.tap(find.byType('ScrollDownArrow'));

      await driver.waitFor(find.byType('SetupPhoneNumberPage'));
      await driver.tap(find.byType('TextField')); // phone number field
      await driver.enterText(
          '88888888'); // this test phone number should always be free during testing
      await driver.tap(find.byType('ScrollDownArrow'));

      await driver.waitFor(find.byType('PhoneVerificationPage'));
      await driver.tap(find.descendant(
        of: find.byType('PhoneVerificationPage'),
        matching: find.byType('DigitEntry'),
        firstMatchOnly: true,
      ));
      for (final digitChar in '123456'.split('')) {
        await driver.enterText(digitChar);
        await Future.delayed(Duration(milliseconds: 100));
      }
      await driver.tap(find.byType('ScrollDownArrow'));

      await driver.waitFor(find.byType('SetupThemePage'));
      await driver.tap(find.text('Light'));

      await driver.waitFor(find.byType('HomePage'));
    });
  });
}
