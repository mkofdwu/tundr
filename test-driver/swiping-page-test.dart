import 'package:test/test.dart';
import 'package:flutter_driver/flutter_driver.dart';

void main() {
  group('Swiping page', () {
    final card = find.byValueKey('card');

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Renders first suggestion correctly', () {});

    test('Cannot undo first suggestion', () async {});

    test('Swipe right on liked suggestion shows its a match page', () async {});

    test('Swipe right on generated suggestion sends suggestion', () async {});

    test('Can undo swipe on previous suggestion', () async {});
  });
}
