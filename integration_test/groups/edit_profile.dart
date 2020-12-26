import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tundr/pages/edit_profile.dart';

import '../utils/auth.dart';

void main() {
  FlutterDriver tester;

  setUpAll(() async {
    tester = await FlutterDriver.connect();
    // should be at home page
    await loginWith(tester);
    await tester.waitFor(find.byType('HomePage'));
    await tester.tap(find.byKey(ValueKey('meTab')));
    await tester.tap(find.text('Profile'));
    await tester.waitFor(find.byType('EditProfilePage'));
  });

  tearDownAll(() async {
    if (tester != null) await tester.close();
  });

  testWidgets('Change about', (tester) async {
    await tester.tap(find.byKey(ValueKey('editAboutMeBtn')));
    await tester.enterText('This is my about (edited)');
    await tester.tap(find.byKey(ValueKey('updateAboutMeBtn')));
    final text = await tester.getText(find.byKey(ValueKey('aboutMeField')));
    expect(text, 'This is my about (edited)');
    // reset
    await tester.tap(find.byKey(ValueKey('aboutMeField')));
    await tester.enterText('This is my about');
    await tester.tap(find.byKey(ValueKey('updateAboutMeBtn')));
  });

  testWidgets('Add extra media', (tester) async {});

  testWidgets('Delete extra media', (tester) async {});

  testWidgets('Replace extra media', (tester) async {});

  testWidgets('Change all personal info', (tester) async {});

  testWidgets(
      'Click personal info but dont change anything', (tester) async {});

  testWidgets('Edit interests', (tester) async {
    await tester.scrollUntilVisible(
        find.byKey(ValueKey('editInterestsBtn')), 100);
    await tester.tap(find.byKey(ValueKey('editInterestsBtn')));
    // at interestseditpage (browser)
    await tester.tap(find.text('Animals'));
    await tester.tap(find.text('Bird Watching'));
    // TODO
  });

  testWidgets('Preview profile', (tester) async {});
}
