import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'utils/login.dart';

void loginTests() {
  var usernameField;
  var passwordField;
  var loginSubmitBtn;

  FlutterDriver driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
    usernameField = find.byValueKey('usernameField');
    passwordField = find.byValueKey('passwordField');
    loginSubmitBtn = find.byValueKey('loginSubmitBtn');
  });

  tearDownAll(() async {
    if (driver != null) await driver.close();
  });

  test('Logs in with correct credentials', () async {
    await loginWith(driver);
  });

  test('Shows error with invalid username or password', () async {
    await loginWith(driver,
        username: 'invalid username', password: 'invalid password');
    await driver.waitFor(find.byType('AlertDialog')); // is this sufficient?
  });
}
