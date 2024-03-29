import 'package:flutter_driver/flutter_driver.dart';

import 'constants.dart';

Future<void> loginWith(
  FlutterDriver driver, {
  String username = USER_USERNAME,
  String password = USER_PASSWORD,
  bool waitForHome = true,
}) async {
  await driver.tap(find.byValueKey('loginBtn'));
  await driver.tap(find.byValueKey('usernameField'));
  await driver.enterText(username);
  await driver.tap(find.byValueKey('passwordField'));
  await driver.enterText(password);
  await driver.tap(find.byValueKey('loginSubmitBtn'));
  if (waitForHome) await driver.waitFor(find.byType('HomePage'));
}

Future<void> logoutWith(FlutterDriver driver) async {
  await driver.tap(find.byValueKey('meTab'));
  await driver.tap(find.text('Settings'));
  await driver.scrollIntoView(find.text('Logout'));
  await driver.tap(find.text('Logout'));
  await driver.tap(find.text('OK'));
  await driver.waitFor(find.byType('WelcomePage'));
}
