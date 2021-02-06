import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tundr/pages/swiping/widgets/suggestion_card.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Renders first suggestion correctly within 4 seconds',
      (tester) async {
    await tester.pump(Duration(seconds: 4));
    expect(find.byType(SuggestionCard), findsOneWidget);
  });

  testWidgets('Cannot undo first suggestion', (tester) async {
    expect(find.byKey(ValueKey('undoBtn')), findsNothing);
  });

  // FIXME: how to test this?
  // testWidgets('Swipe right on liked suggestion shows its a match page', (tester) async {});

  var nameAndAge;

  testWidgets('Swipe right on generated suggestion sends suggestion',
      (tester) async {
    // all suggestions were on generated on account create
    final suggestionCard = find.byType(SuggestionCard);
    final gesture = await tester.startGesture(tester.getCenter(suggestionCard));
    await gesture.moveBy(Offset(200, 0));
    await tester.pump();
    nameAndAge = await tester
        .getSemantics(
          find.descendant(of: suggestionCard, matching: find.byType(Text)),
        )
        .value;
    debugPrint('name and age retrieved: ' + nameAndAge);
  });

  testWidgets('Can undo swipe on previous suggestion', (tester) async {
    await tester.tap(find.byKey(ValueKey('undoBtn')));
    expect(
      find.descendant(
        of: find.byType(SuggestionCard),
        matching: find.text(nameAndAge),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Swipe left on generated suggestion', (tester) async {
    final suggestionCard = find.byType(SuggestionCard);
    final gesture = await tester.startGesture(tester.getCenter(suggestionCard));
    await gesture.moveBy(Offset(200, 0));
    await tester.pump();
  });

  testWidgets('Buttons have same effect', (tester) async {
    // FIXME
  });

  testWidgets('Match and start conversation', (tester) async {});

  testWidgets('Match and undo', (tester) async {});

  testWidgets('Match and continue swiping', (tester) async {});
}
