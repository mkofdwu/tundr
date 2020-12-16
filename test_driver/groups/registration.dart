import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

const NEW_USERNAME = 'username2';
const NEW_PASSWORD = 'password2';

void registrationTests() {
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

  test('Registration flow works correctly', () async {
    await registerWith(driver, NEW_USERNAME, NEW_PASSWORD, NEW_PASSWORD);

    await driver.runUnsynchronized(() async {
      await driver.waitFor(find.byType('SetupNamePage'));
      await driver.tap(find.byValueKey('nameField'));
      await driver.enterText(NEW_USERNAME);
      await driver.tap(find.byType('ScrollDownArrow'));

      await driver.waitFor(find.byType('SetupBirthdayPage'));
      await driver.tap(find.descendant(
        of: find.byType('SetupBirthdayPage'),
        matching: find.byType('DigitEntry'),
        firstMatchOnly: true,
      ));
      for (final numChar in '20102005'.split('')) {
        await driver.enterText(numChar);
        await Future.delayed(Duration(seconds: 1));
      }
      await driver.scroll(
          find.byType('SetupBirthdayPage'), 0, -3.0, Duration(seconds: 1));

      await driver.waitFor(find.byType('SetupGenderPage'));
      await driver.tap(find.text('Male'));
      await driver.tap(find.byType('ScrollDownArrow'));

      await driver.waitFor(find.byType('SetupProfilePicPage'));
      await driver.tap(find.text('Camera'));
      await driver.waitFor(null, timeout: Duration(minutes: 2));

      // await driver.waitFor(find.byType('SetupInterestsPage'));

      // await driver.waitFor(find.byType('SetupPhoneNumberPage'));

      // await driver.waitFor(find.byType('PhoneVerificationPage'));
    });

    await driver.waitFor(find.byType('SetupBirthdayPage'));
    await driver.tap(find.byType('DigitEntry'));
    await driver.enterText('2');
    await driver.enterText('0');
    await driver.enterText('1');
    await driver.enterText('0');
    await driver.enterText('2');
    await driver.enterText('0');
    await driver.enterText('0');
    await driver.enterText('5');
    await driver.scroll(
        find.byType('SetupBirthdayPage'), 0, -3.0, Duration(seconds: 1));

    await driver.waitFor(find.byType('SetupGenderPage'));
    await driver.tap(find.text('Male'));
    await driver.tap(find.byType('ScrollDownArrow'));

    await driver.waitFor(find.byType('SetupProfilePicPage'));
    await driver.tap(find.text('Camera'));
    await driver.waitFor(null, timeout: Duration(minutes: 2));

    // await driver.waitFor(find.byType('SetupInterestsPage'));

    // await driver.waitFor(find.byType('SetupPhoneNumberPage'));

    // await driver.waitFor(find.byType('PhoneVerificationPage'));
  });

  // test('Shows error with existing username or not matching passwords', () async {
  //   await registerWith(driver, 'username1', 'password');
  //   await driver.waitFor(find.byType('AlertDialog')); // is this sufficient?
  // });

  // test('Delete account', () async {
  //   await driver.tap(find.byValueKey('dashboardTab'));
  //   await driver.tap(find.byValueKey('settingsBtn'));
  //   await driver.tap(find.byValueKey('deleteAccountBtn'));
  //   await driver.tap(find.byValueKey('confirmPasswordField'));
  //   await driver.enterText(NEW_PASSWORD);
  //   await driver.tap(find.byValueKey('confirmDeleteAccountBtn'));
  //   await driver.waitFor(find.byType('WelcomePage'));
  //   await driver.waitFor(
  //       find.text('Success')); // alert dialog showing account has been deleted
  // });
}
