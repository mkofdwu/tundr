import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'utils/login.dart';

const NEW_USERNAME = 'username2';
const NEW_PASSWORD = 'password2';

void registrationTests() {
  final registerBtn = find.byValueKey('registerBtn');
  var usernameField;
  var passwordField;
  var registerSubmitBtn;

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
  ) async {
    await driver.tap(registerBtn);
    await driver.tap(usernameField);
    await driver.enterText(username);
    await driver.tap(passwordField);
    await driver.enterText(password);
    await driver.tap(registerSubmitBtn);
  }

  test('Registration flow works correctly', () async {
    await registerWith(driver, NEW_USERNAME, NEW_PASSWORD);
    await driver.waitFor(find.byType('SetupNamePage'));
    // TODO
  });

  test('Shows error with existing username', () async {
    await registerWith(driver, 'username1', 'password');
    await driver.waitFor(find.byType('AlertDialog')); // is this sufficient?
  });

  test('Delete account', () async {
    await loginWith(driver, username: NEW_USERNAME, password: NEW_PASSWORD);
    await driver.tap(find.byValueKey('tab0'));
    await driver.waitFor(find.byType('DashboardPage'));
    await driver.tap(find.byValueKey('settingsBtn'));
    await driver.waitFor(find.byType('SettingsPage'));
    await driver.tap(find.byValueKey('deleteAccountBtn'));
    await driver.waitFor(find.byType('ConfirmDeleteAccountPage'));
    await driver.tap(find.byValueKey('confirmPasswordField'));
    await driver.enterText(NEW_PASSWORD);
    await driver.tap(find.byValueKey('confirmDeleteAccountBtn'));
    await driver.waitFor(find.byType('WelcomePage'));
    // TODO: alert showing account has been deleted
  });
}
