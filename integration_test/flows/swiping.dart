import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tundr/pages/its_a_match.dart';
import 'package:tundr/pages/swiping/widgets/suggestion_card.dart';

Future<void> rendersSuggestionWithin(tester, {int seconds = 4}) async {
  await tester.pump(Duration(seconds: seconds));
  expect(find.byType(SuggestionCard), findsOneWidget);
}

Future<String> getSuggestionNameAndAge(tester) async {
  final nameAndAge = await tester
      .getSemantics(
        find.descendant(
            of: find.byType(SuggestionCard), matching: find.byType(Text)),
      )
      .value;
  debugPrint('name and age retrieved: ' + nameAndAge);

  return nameAndAge;
}

Future<void> swipeRight(tester) async {
  // all suggestions were on generated on account create
  final suggestionCard = find.byType(SuggestionCard);
  final gesture = await tester.startGesture(tester.getCenter(suggestionCard));
  await gesture.moveBy(Offset(200, 0));
  await tester.pump();
}

Future<void> swipeLeft(tester) async {
  final suggestionCard = find.byType(SuggestionCard);
  final gesture = await tester.startGesture(tester.getCenter(suggestionCard));
  await gesture.moveBy(Offset(200, 0));
  await tester.pump();
}

Future<void> undo(tester) async {
  await tester.tap(find.byKey(ValueKey('undoBtn')));
}

Future<void> clickLikeButton(tester) async {}

Future<void> clickNopeButton(tester) async {}

Future<void> matchAndStartConversation(tester) async {
  expect(find.byType(ItsAMatchPage), findsOneWidget);
}

Future<void> undoMatch(tester) async {
  expect(find.byType(ItsAMatchPage), findsOneWidget);
}

Future<void> matchAndContinue(tester) async {
  expect(find.byType(ItsAMatchPage), findsOneWidget);
}
