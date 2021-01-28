import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:tundr/main.dart' as app;
import 'package:tundr/pages/edit_profile.dart';
import 'package:tundr/pages/home.dart';
import 'package:tundr/pages/media/edit_extra_media.dart';
import 'package:tundr/pages/personal_info/widgets/personal_info_list.dart';
import 'package:tundr/pages/profile/main.dart';
import 'package:tundr/widgets/buttons/back.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> setupTest(WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
    await tester.tap(find.byKey(ValueKey('meTab')));
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.byType(EditProfilePage), findsOneWidget);
  }

  testWidgets('Change about', (tester) async {
    await setupTest(tester);
    await tester.enterText(
        find.byKey(ValueKey('editAboutMeBtn')), 'This is my about (edited)');
    await tester.tap(find.byKey(ValueKey('updateAboutMeBtn')));
    final text =
        await tester.getSemantics(find.byKey(ValueKey('aboutMeField')));
    expect(
      text,
      matchesSemantics(isTextField: true, value: 'This is my about (edited)'),
    );
    // reset
    await tester.enterText(
        find.byKey(ValueKey('aboutMeField')), 'This is my about');
    await tester.tap(find.byKey(ValueKey('updateAboutMeBtn')));
  });

  testWidgets('Add extra media', (tester) async {
    await tester.tap(find.byKey(ValueKey('extraMediaEditTile0')));
    await tester.tap(find.text('Image'));
    await tester.tap(find.text('Camera'));
    await tester.tap(find.byKey(ValueKey('extraMediaEditTile5')));
    await tester.tap(find.text('Video'));
    await tester.tap(find.text('Camera'));
  });

  testWidgets('Replace extra media', (tester) async {
    await tester.tap(find.byKey(ValueKey('extraMediaEditTile0')));
    await tester.pumpAndSettle();
    expect(find.byType(EditExtraMediaPage), findsOneWidget);
    await tester.tap(find.byKey(ValueKey('menu')));
    await tester.tap(find.text('Replace with video')); // video
    await tester.tap(find.byType(MyBackButton));
  });

  testWidgets('Delete extra media', (tester) async {
    await tester.tap(find.byKey(ValueKey('extraMediaEditTile0')));
    await tester.pumpAndSettle();
    expect(find.byType(EditExtraMediaPage), findsOneWidget);
    await tester.tap(find.byKey(ValueKey('menu')));
    await tester.tap(find.byKey(ValueKey('deleteBtn')));
    await tester.pumpAndSettle();
    expect(find.byType(EditProfilePage), findsOneWidget);
  });

  testWidgets('Change all personal info', (tester) async {
    await tester.scrollUntilVisible(find.byType(PersonalInfoList), 100);
    await tester.tap(find.byKey(ValueKey('School')));
    await tester.tap(find.byKey(ValueKey('Height')));
    // TODO FIXME
  });

  testWidgets('Edit interests (includes interestbrowser)', (tester) async {
    await tester.scrollUntilVisible(
        find.byKey(ValueKey('editInterestsBtn')), 100);
    await tester.tap(find.byKey(ValueKey('editInterestsBtn')));
    // at interestseditpage (browser)
    await tester.tap(find.text('Animals'));
    await tester.tap(find.text('Bird Watching'));
    // TODO
  });

  testWidgets('Preview profile', (tester) async {
    await tester.tap(find.byKey(ValueKey('previewProfileBtn')));
    await tester.pumpAndSettle();
    expect(find.byType(MainProfilePage), findsOneWidget);
    expect(find.text('test, 15'), findsOneWidget);
    expect(find.byKey(ValueKey('chatWithUserBtn')), findsNothing);
    await tester.tap(find.byType(MyBackButton));
  });
}
