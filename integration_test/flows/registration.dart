import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tundr/pages/home.dart';
import 'package:tundr/pages/register.dart';
import 'package:tundr/pages/setup/birthday.dart';
import 'package:tundr/pages/setup/gender.dart';
import 'package:tundr/pages/setup/interests.dart';
import 'package:tundr/pages/setup/name.dart';
import 'package:tundr/pages/setup/phone_number.dart';
import 'package:tundr/pages/setup/phone_verification.dart';
import 'package:tundr/pages/setup/profile_pic.dart';
import 'package:tundr/pages/setup/theme.dart';
import 'package:tundr/widgets/scroll_down_arrow.dart';
import 'package:tundr/widgets/textfields/digit.dart';

import '../accounts.dart';
import '../utils.dart';

Future<void> _registerWith(
  WidgetTester tester,
  String username,
  String password,
  String confirmPassword, {
  bool waitForSettle = true,
}) async {
  expect(find.byType(RegisterPage), findsOneWidget);
  await tester.enterText(find.byKey(ValueKey('usernameField')), username);
  await tester.enterText(find.byKey(ValueKey('passwordField')), password);
  await tester.enterText(
      find.byKey(ValueKey('confirmPasswordField')), confirmPassword);
  await tester.tap(find.text('Setup'));
  if (waitForSettle) await tester.pumpAndSettle();
}

Future<void> invalidRegistration(WidgetTester tester) async {
  // existing username
  await _registerWith(tester, 'test', 'password', 'password');
  expect(find.text('This username is already taken'), findsOneWidget);
  // not matching passwords
  await _registerWith(tester, 'username9978', 'password', 'password1');
  expect(find.text('The passwords do not match'), findsOneWidget);
  // invalid username
  await _registerWith(tester, ' usernam\ne9978\r \t', 'password', 'password');
  expect(find.text('Your username cannot contain any spaces'), findsOneWidget);
  // nothing
  await _registerWith(tester, '', '', '');
  expect(find.text('Your username must be at least 4 characters long'),
      findsOneWidget);
  expect(find.text('Your password must be at least 6 characters long'),
      findsOneWidget);
}

Future<void> registerWith(WidgetTester tester, Account account) async {
  await _registerWith(
    tester,
    account.username,
    account.password,
    account.password,
    waitForSettle: false,
  );
  // can't pumpAndSettle because the scrolldownarrow is still animating
  await pump(tester, Duration(seconds: 1), 3);

  expect(find.byType(SetupNamePage), findsOneWidget);
  await tester.enterText(find.byKey(ValueKey('nameField')), account.username);
  await tester.tap(find.byType(ScrollDownArrow));

  await tester.pump(Duration(seconds: 1));
  expect(find.byType(SetupBirthdayPage), findsOneWidget);
  var index = 0;
  for (final digitChar in '20102005'.split('')) {
    await tester.enterText(find.byType(DigitEntry).at(index++), digitChar);
    await Future.delayed(Duration(milliseconds: 100));
  }
  await tester.tap(find.byType(ScrollDownArrow));

  await tester.pump(Duration(seconds: 1));
  expect(find.byType(SetupGenderPage), findsOneWidget);
  await tester.tap(find.text('Male'));
  await tester.tap(find.byType(ScrollDownArrow));

  await tester.pump(Duration(seconds: 1));
  expect(find.byType(SetupProfilePicPage), findsOneWidget);
  await tester.tap(find.text('Camera'));
  // image will be taken automatically
  await tester.pump(Duration(seconds: 1));
  await tester.tap(find.byType(ScrollDownArrow));

  await tester.pump(Duration(seconds: 1));
  expect(find.byType(SetupInterestsPage), findsOneWidget);
  await tester.tap(find.text('Custom'));
  await tester.pump(Duration(milliseconds: 100));
  await tester.tap(find.text('Add new'));
  await tester.pump();
  await tester.enterText(
      find.byKey(ValueKey('addCustomInterestField')), 'my custom interest');
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.tap(find.text('Animals'));
  await tester.pump(Duration(milliseconds: 100));
  await tester.tap(find.text('Animals').at(1));
  await tester.tap(find.text('Birds'));
  await tester.tap(find.text('Cats'));
  await tester.tap(find.text('Dogs'));
  await tester.tap(find.text('Outdoors'));
  await tester.pump(Duration(milliseconds: 100));
  await tester.tap(find.text('Hiking'));
  await tester.tap(find.text('Camping'));
  await tester.tap(find.text('Climbing'));
  await tester.tap(find.text('Environment'));
  await tester.tap(find.text('Nature'));
  await tester.enterText(find.byType(TextField), 'comput'); // search field
  await tester.pump(Duration(milliseconds: 100));
  await tester.tap(find.text('Computers'));
  await tester.tap(find.text('Computer Graphics'));
  await tester.tap(find.text('Computer Science'));
  await tester.tap(find.text('Computer Security'));
  await tester.tap(find.text('Computer Hardware'));
  await tester.tap(find.byType(ScrollDownArrow));

  await tester.pump(Duration(seconds: 1));
  expect(find.byType(SetupPhoneNumberPage), findsOneWidget);
  await tester.enterText(
    find.byType(TextField), // phone number field
    '88888888', // this test phone number should always be free during testing
  );
  await tester.tap(find.byType(ScrollDownArrow));

  await pump(tester, Duration(seconds: 1), 4);
  expect(find.byType(PhoneVerificationPage), findsOneWidget);
  await tester.tap(
    find
        .descendant(
          of: find.byType(PhoneVerificationPage),
          matching: find.byType(DigitEntry),
        )
        .first,
  );
  var index1 = 0;
  for (final digitChar in '123456'.split('')) {
    final digitEntry = find.byType(DigitEntry).at(index1++);
    await tester.enterText(digitEntry, digitChar);
    await Future.delayed(Duration(milliseconds: 100));
  }
  await tester.tap(find.byType(ScrollDownArrow));

  await pump(tester, Duration(seconds: 1), 20);
  expect(find.byType(SetupThemePage), findsOneWidget);
  await tester.tap(find.text('Light'));

  await tester.pump(Duration(seconds: 2));
  expect(find.byType(HomePage), findsOneWidget);

  Accounts.current = account;
}
