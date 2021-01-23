import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  FlutterDriver driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  test('Renders first suggestion correctly within 4 seconds', () async {
    await driver.waitFor(find.byType('SuggestionCard'),
        timeout: Duration(seconds: 4));
  });

  test('Cannot undo first suggestion', () async {
    await driver.waitForAbsent(find.byValueKey('undoBtn'));
  });

  // FIXME: how to test this?
  // test('Swipe right on liked suggestion shows its a match page', () async {});

  var nameAndAge;

  test('Swipe right on generated suggestion sends suggestion', () async {
    // all suggestions were on generated on account create
    final suggestionCard = find.byType('SuggestionCard');
    await driver.scroll(suggestionCard, -200, 0, Duration(milliseconds: 500));
    nameAndAge = await driver.getText(
      find.descendant(of: suggestionCard, matching: find.byType('Text')),
    );
  });

  test('Can undo swipe on previous suggestion', () async {
    await driver.tap(find.byValueKey('undoBtn'));
    await driver.waitFor(find.descendant(
      of: find.byType('SuggestionCard'),
      matching: find.text(nameAndAge),
    ));
  });

  test('Swipe left on generated suggestion', () async {
    final suggestionCard = find.byType('SuggestionCard');
    await driver.scroll(suggestionCard, 200, 0, Duration(milliseconds: 500));
  });

  test('Buttons have same effect', () async {
    // FIXME
  });
}
