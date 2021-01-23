import 'package:flutter/foundation.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tundr/pages/filters/checkbox_filter.dart';
import 'package:tundr/pages/filters/range_slider_filter.dart';
import 'package:tundr/pages/filters/text_list_filter.dart';
import 'package:tundr/widgets/buttons/back.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('filters are displayed correctly', (tester) async {
    await tester.tap(find.byKey(ValueKey('meTab')));
    await tester.tap(find.text('Settings'));
    await tester.scrollIntoView(find.text('Filters'));
    await tester.tap(find.text('Filters'));
    await tester.waitFor(find.descendant(
      of: find.byKey(ValueKey('Height')),
      matching: find.text('1, 300'),
    ));
    await tester.waitFor(find.descendant(
      of: find.byKey(ValueKey('Personality')),
      matching: find.text('2, 4'),
    ));
  });

  testWidgets('change height filter', (tester) async {
    await tester.tap(find.byKey(ValueKey('Height')));
    await tester.waitFor(find.byType(RangeSliderFilterPage));
    // TODO FIXME dont know how to drag the slider
    await tester.tap(find.byType(MyBackButton));
  });

  testWidgets('change pets filter', (tester) async {
    await tester.tap(find.byKey(ValueKey('Pets')));
    await tester.waitFor(find.byType(TextListFilterPage));
    await tester.tap(find.text('No filter'));
    await tester.tap(find.text('Cannot contain any of ...'));
    await tester.enterText(find.text('Add new'), 'Cat');
    // TODO FIXME dont know how to press enter
    await tester.tap(find.byType(MyBackButton));
  });

  testWidgets('change star sign filter', (tester) async {
    await tester.tap(find.byKey(ValueKey('Star sign')));
    await tester.waitFor(find.byType(CheckboxFilterPage));
    await tester.tap(find.text('Aries'));
    await tester.tap(find.text('Cancer'));
    await tester.tap(find.byType(MyBackButton));
    await tester.waitFor(find.text('Aries, Cancer'));
  });

  testWidgets('reset star sign', (tester) async {
    await tester.tap(find.byKey(ValueKey('Star sign')));
    await tester.waitFor(find.byType(CheckboxFilterPage));
    await tester.tap(find.text('Aries'));
    await tester.tap(find.text('Cancer'));
    await tester.tap(find.byType(MyBackButton));
    await tester.waitForAbsent(find.text('Aries, Cancer'));
  });
}
