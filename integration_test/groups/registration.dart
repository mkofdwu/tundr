import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/processes.dart';

const NEW_USERNAME = 'username2';
const NEW_PASSWORD = 'password2';

void main() {
  FlutterDriver tester;

  setUpAll(() async {
    tester = await FlutterDriver.connect();
  });

  tearDownAll(() {
    if (tester != null) tester.close();
  });

  Future<void> registerWith(
    FlutterDriver tester,
    String username,
    String password,
    String confirmPassword,
  ) async {
    await tester.tap(find.byKey(ValueKey('registerBtn')));
    await tester.tap(find.byKey(ValueKey('usernameField')));
    await tester.enterText(username);
    await tester.tap(find.byKey(ValueKey('passwordField')));
    await tester.enterText(password);
    await tester.tap(find.byKey(ValueKey('confirmPasswordField')));
    await tester.enterText(confirmPassword);
    await tester.tap(find.text('Setup'));
  }

  testWidgets('Registration flow works correctly', () async {
    await registerWith(tester, NEW_USERNAME, NEW_PASSWORD, NEW_PASSWORD);

    await tester.runUnsynchronized(() async {
      await tester.waitFor(find.byType('SetupNamePage'));
      await tester.tap(find.byKey(ValueKey('nameField')));
      await tester.enterText(NEW_USERNAME);
      await tester.tap(find.byType('ScrollDownArrow'));

      await tester.waitFor(find.byType('SetupBirthdayPage'));
      await tester.tap(find.byKey(ValueKey('digit1')));
      for (final digitChar in '20102005'.split('')) {
        await tester.enterText(digitChar);
        await Future.delayed(Duration(milliseconds: 100));
      }
      await tester.tap(find.byType('ScrollDownArrow'));

      await tester.waitFor(find.byType('SetupGenderPage'));
      await tester.tap(find.text('Male'));
      await tester.tap(find.byType('ScrollDownArrow'));

      await tester.waitFor(find.byType('SetupProfilePicPage'));
      await tester.tap(find.text('Camera'));
      // image will be taken automatically
      await tester.tap(find.byType('ScrollDownArrow'));

      await tester.waitFor(find.byType('SetupInterestsPage'));
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
      await tester.tap(find.byType('TextField')); // search field
      await tester.enterText('comput');
      await tester.tap(find.text('Computers'));
      await tester.tap(find.text('Computer Graphics'));
      await tester.tap(find.text('Computer Science'));
      await tester.tap(find.text('Computer Security'));
      await tester.tap(find.text('Computer Hardware'));
      await tester.tap(find.byType('ScrollDownArrow'));

      await tester.waitFor(find.byType('SetupPhoneNumberPage'));
      await tester.tap(find.byType('TextField')); // phone number field
      await tester.enterText(
          '88888888'); // this test phone number should always be free during testing
      await tester.tap(find.byType('ScrollDownArrow'));

      await tester.waitFor(find.byType('PhoneVerificationPage'));
      await tester.tap(find.descendant(
        of: find.byType('PhoneVerificationPage'),
        matching: find.byType('DigitEntry'),
        firstMatchOnly: true,
      ));
      for (final digitChar in '123456'.split('')) {
        await tester.enterText(digitChar);
        await Future.delayed(Duration(milliseconds: 100));
      }
      await tester.tap(find.byType('ScrollDownArrow'));

      await tester.waitFor(find.byType('SetupThemePage'));
      await tester.tap(find.text('Light'));

      await tester.waitFor(find.byType('HomePage'));
    });
  });

  testWidgets('Delete account', () async {
    await tester.tap(find.byKey(ValueKey('meTab')));
    await tester.tap(find.byKey(ValueKey('settingsBtn')));
    await tester.scrollIntoView(find.byKey(ValueKey('deleteAccountBtn')));
    await tester.tap(find.byKey(ValueKey('deleteAccountBtn')));
    await tester.tap(find.byKey(ValueKey('confirmPasswordField')));
    await tester.enterText(NEW_PASSWORD);
    await tester.tap(find.byKey(ValueKey('confirmDeleteAccountBtn')));
    await tester.waitFor(find.byType('WelcomePage'));
  });

  testWidgets('Shows error with invalid input', () async {
    // existing username
    await registerWith(tester, 'test', 'password', 'password');
    await tester.waitFor(find.byType('AlertDialog'));
    await tester.tap(find.text('CLOSE'));
    await back();
    // not matching passwords
    await registerWith(tester, 'username9978', 'password', 'password1');
    await tester.waitFor(find.byType('AlertDialog'));
    await tester.tap(find.text('CLOSE'));
    await back();
    // invalid username
    await registerWith(tester, ' usernam\ne9978\r \t', 'password', 'password');
    await tester.waitFor(find.byType('AlertDialog'));
    await tester.tap(find.text('CLOSE'));
    await back();
    // nothing
    await registerWith(tester, '', '', '');
    await tester.waitFor(find.byType('AlertDialog'));
    await tester.tap(find.text('CLOSE'));
    await back();
  });
}
