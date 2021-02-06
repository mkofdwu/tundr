import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tundr/pages/edit_profile/edit_profile.dart';
import 'package:tundr/pages/media/edit_extra_media.dart';
import 'package:tundr/pages/personal_info/widgets/personal_info_list.dart';
import 'package:tundr/pages/profile/main.dart';
import 'package:tundr/widgets/buttons/back.dart';

Future<void> changeAbout(WidgetTester tester) async {
  await tester.enterText(
      find.byKey(ValueKey('editAboutMeBtn')), 'This is my about (edited)');
  await tester.tap(find.byKey(ValueKey('updateAboutMeBtn')));
  final text = await tester.getSemantics(find.byKey(ValueKey('aboutMeField')));
  expect(
    text,
    matchesSemantics(isTextField: true, value: 'This is my about (edited)'),
  );
  // reset
  await tester.enterText(
      find.byKey(ValueKey('aboutMeField')), 'This is my about');
  await tester.tap(find.byKey(ValueKey('updateAboutMeBtn')));
}

Future<void> addExtraMedia(tester) async {
  await tester.tap(find.byKey(ValueKey('extraMediaEditTile0')));
  await tester.tap(find.text('Image'));
  await tester.tap(find.text('Camera'));
  await tester.tap(find.byKey(ValueKey('extraMediaEditTile5')));
  await tester.tap(find.text('Video'));
  await tester.tap(find.text('Camera'));
}

Future<void> replaceExtraMedia(tester) async {
  await tester.tap(find.byKey(ValueKey('extraMediaEditTile0')));
  await tester.pumpAndSettle();
  expect(find.byType(EditExtraMediaPage), findsOneWidget);
  await tester.tap(find.byKey(ValueKey('menu')));
  await tester.tap(find.text('Replace with video')); // video
  await tester.tap(find.byType(MyBackButton));
}

Future<void> deleteExtraMedia(tester) async {
  await tester.tap(find.byKey(ValueKey('extraMediaEditTile0')));
  await tester.pumpAndSettle();
  expect(find.byType(EditExtraMediaPage), findsOneWidget);
  await tester.tap(find.byKey(ValueKey('menu')));
  await tester.tap(find.byKey(ValueKey('deleteBtn')));
  await tester.pumpAndSettle();
  expect(find.byType(EditProfilePage), findsOneWidget);
}

Future<void> changePersonalInfo(tester) async {
  await tester.scrollUntilVisible(find.byType(PersonalInfoList), 100);
  await tester.tap(find.byKey(ValueKey('School')));
  await tester.tap(find.byKey(ValueKey('Height')));
  // TODO FIXME
}

Future<void> editInterests(tester) async {
  await tester.scrollUntilVisible(
      find.byKey(ValueKey('editInterestsBtn')), 100);
  await tester.tap(find.byKey(ValueKey('editInterestsBtn')));
  // at interestseditpage (browser)
  await tester.tap(find.text('Animals'));
  await tester.tap(find.text('Bird Watching'));
  // TODO
}

Future<void> previewProfile(tester) async {
  await tester.tap(find.byKey(ValueKey('previewProfileBtn')));
  await tester.pumpAndSettle();
  expect(find.byType(MainProfilePage), findsOneWidget);
  expect(find.text('test, 15'), findsOneWidget);
  expect(find.byKey(ValueKey('chatWithUserBtn')), findsNothing);
  await tester.tap(find.byType(MyBackButton));
}
