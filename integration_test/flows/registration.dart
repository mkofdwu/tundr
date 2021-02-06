import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tundr/pages/home.dart';
import 'package:tundr/pages/setup/birthday.dart';
import 'package:tundr/pages/setup/gender.dart';
import 'package:tundr/pages/setup/interests.dart';
import 'package:tundr/pages/setup/name.dart';
import 'package:tundr/pages/setup/phone_number.dart';
import 'package:tundr/pages/setup/phone_verification.dart';
import 'package:tundr/pages/setup/profile_pic.dart';
import 'package:tundr/pages/setup/theme.dart';
import 'package:tundr/pages/welcome.dart';
import 'package:tundr/widgets/scroll_down_arrow.dart';
import 'package:tundr/widgets/textfields/digit.dart';

import '../accounts.dart';
import '../utils.dart';

Future<void> _registerWith(
  WidgetTester tester,
  String username,
  String password,
  String confirmPassword,
) async {
  expect(find.byType(WelcomePage), findsOneWidget);
  await tester.tap(find.byKey(ValueKey('registerBtn')));
  await tester.enterText(find.byKey(ValueKey('usernameField')), username);
  await tester.enterText(find.byKey(ValueKey('passwordField')), password);
  await tester.enterText(
      find.byKey(ValueKey('confirmPasswordField')), confirmPassword);
  await tester.tap(find.text('Setup'));
}

Future<void> invalidRegistration(WidgetTester tester) async {
  // existing username
  await _registerWith(tester, 'test', 'password', 'password');
  await tester.pumpAndSettle();
  expect(find.byType(AlertDialog), findsOneWidget);
  await tester.tap(find.text('CLOSE'));
  await back();
  // not matching passwords
  await _registerWith(tester, 'username9978', 'password', 'password1');
  await tester.pumpAndSettle();
  expect(find.byType(AlertDialog), findsOneWidget);
  await tester.tap(find.text('CLOSE'));
  await back();
  // invalid username
  await _registerWith(tester, ' usernam\ne9978\r \t', 'password', 'password');
  await tester.pumpAndSettle();
  expect(find.byType(AlertDialog), findsOneWidget);
  await tester.tap(find.text('CLOSE'));
  await back();
  // nothing
  await _registerWith(tester, '', '', '');
  await tester.pumpAndSettle();
  expect(find.byType(AlertDialog), findsOneWidget);
  await tester.tap(find.text('CLOSE'));
  await back();
}

Future<void> registerWith(WidgetTester tester, Account account) async {
  await _registerWith(
      tester, account.username, account.password, account.password);

  await tester.pumpAndSettle();
  expect(find.byType(SetupNamePage), findsOneWidget);
  await tester.enterText(find.byKey(ValueKey('nameField')), account.username);
  await tester.tap(find.byType(ScrollDownArrow));

  await tester.pumpAndSettle();
  expect(find.byType(SetupBirthdayPage), findsOneWidget);
  var index = 0;
  for (final digitChar in '20102005'.split('')) {
    await tester.enterText(find.byType(DigitEntry).at(index++), digitChar);
    await Future.delayed(Duration(milliseconds: 100));
  }
  await tester.tap(find.byType(ScrollDownArrow));

  await tester.pumpAndSettle();
  expect(find.byType(SetupGenderPage), findsOneWidget);
  await tester.tap(find.text('Male'));
  await tester.tap(find.byType(ScrollDownArrow));

  await tester.pumpAndSettle();
  expect(find.byType(SetupProfilePicPage), findsOneWidget);
  await tester.tap(find.text('Camera'));
  // image will be taken automatically
  await tester.tap(find.byType(ScrollDownArrow));

  await tester.pumpAndSettle();
  expect(find.byType(SetupInterestsPage), findsOneWidget);
  // await tester.tap(find.text('Custom'));
  // await tester.tap(find.text('Add new'));
  // await tester.enterText('my custom interest\n');
  // await tester.tap(find.text('Animals'));
  await tester.tap(find.text('Birds'));
  await tester.tap(find.text('Cats'));
  await tester.tap(find.text('Dogs'));
  await tester.tap(find.text('Outdoors'));
  await tester.tap(find.text('Hiking'));
  await tester.tap(find.text('Camping'));
  await tester.tap(find.text('Climbing'));
  await tester.tap(find.text('Environment'));
  await tester.tap(find.text('Nature'));
  await tester.enterText(find.byType(TextField), 'comput'); // search field
  await tester.tap(find.text('Computers'));
  await tester.tap(find.text('Computer Graphics'));
  await tester.tap(find.text('Computer Science'));
  await tester.tap(find.text('Computer Security'));
  await tester.tap(find.text('Computer Hardware'));
  await tester.tap(find.byType(ScrollDownArrow));

  await tester.pumpAndSettle();
  expect(find.byType(SetupPhoneNumberPage), findsOneWidget);
  await tester.enterText(
    find.byType(TextField), // phone number field
    '88888888', // this test phone number should always be free during testing
  );
  await tester.tap(find.byType(ScrollDownArrow));

  await tester.pumpAndSettle();
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

  await tester.pumpAndSettle();
  expect(find.byType(SetupThemePage), findsOneWidget);
  await tester.tap(find.text('Light'));

  await tester.pumpAndSettle();
  expect(find.byType(HomePage), findsOneWidget);
}
