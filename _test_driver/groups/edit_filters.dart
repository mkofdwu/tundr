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

  test('filters are displayed correctly', () async {
    await driver.tap(find.byValueKey('meTab'));
    await driver.tap(find.text('Settings'));
    await driver.scrollIntoView(find.text('Filters'));
    await driver.tap(find.text('Filters'));
    await driver.waitFor(find.descendant(
      of: find.byValueKey('Height'),
      matching: find.text('1, 300'),
    ));
    await driver.waitFor(find.descendant(
      of: find.byValueKey('Personality'),
      matching: find.text('2, 4'),
    ));
  });

  test('change height filter', () async {
    await driver.tap(find.byValueKey('Height'));
    await driver.waitFor(find.byType('RangeSliderFilterPage'));
    // FIXME dont know how to drag the slider
    await driver.tap(find.byType('MyBackButton'));
  });

  test('change pets filter', () async {
    await driver.tap(find.byValueKey('Pets'));
    await driver.waitFor(find.byType('TextListFilterPage'));
    await driver.tap(find.text('No filter'));
    await driver.tap(find.text('Cannot contain any of ...'));
    await driver.tap(find.text('Add new'));
    await driver.enterText('Cat');
    // FIXME dont know how to press enter
    await driver.tap(find.byType('MyBackButton'));
  });

  test('change star sign filter', () async {
    await driver.tap(find.byValueKey('Star sign'));
    await driver.waitFor(find.byType('CheckboxFilterPage'));
    await driver.tap(find.text('Aries'));
    await driver.tap(find.text('Cancer'));
    await driver.tap(find.byType('MyBackButton'));
    await driver.waitFor(find.text('Aries, Cancer'));
  });

  test('reset star sign', () async {
    await driver.tap(find.byValueKey('Star sign'));
    await driver.waitFor(find.byType('CheckboxFilterPage'));
    await driver.tap(find.text('Aries'));
    await driver.tap(find.text('Cancer'));
    await driver.tap(find.byType('MyBackButton'));
    await driver.waitForAbsent(find.text('Aries, Cancer'));
  });
}
