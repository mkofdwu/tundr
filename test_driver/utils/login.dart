import 'package:flutter_driver/flutter_driver.dart';

Future<void> loginWith(
  driver, {
  String username = 'username1',
  String password = 'password1',
}) async {
  await driver.tap(find.byValueKey('loginBtn'));
  await driver.tap(find.byValueKey('usernameField'));
  await driver.enterText(username);
  await driver.tap(find.byValueKey('passwordField'));
  await driver.enterText(password);
  await driver.tap(find.byValueKey('loginSubmitBtn'));
  await driver.waitFor(find.byType('HomePage'));
}
