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
    await tester.scrollUntilVisible(find.text('Filters'), 100);
    await tester.tap(find.text('Filters'));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byKey(ValueKey('Height')),
        matching: find.text('1, 300'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(ValueKey('Personality')),
        matching: find.text('2, 4'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('change height filter', (tester) async {
    await tester.tap(find.byKey(ValueKey('Height')));
    await tester.pumpAndSettle();
    expect(find.byType(RangeSliderFilterPage), findsOneWidget);
    // TODO FIXME dont know how to drag the slider
    await tester.tap(find.byType(MyBackButton));
    await tester.pumpAndSettle();
    // FIXME: write expect
  });

  testWidgets('change pets filter', (tester) async {
    await tester.tap(find.byKey(ValueKey('Pets')));
    await tester.pumpAndSettle();
    expect(find.byType(TextListFilterPage), findsOneWidget);
    await tester.tap(find.text('No filter'));
    await tester.tap(find.text('Cannot contain any of ...'));
    await tester.enterText(find.text('Add new'), 'Cat');
    // TODO FIXME dont know how to press enter
    await tester.tap(find.byType(MyBackButton));
    await tester.pumpAndSettle();
    // FIXME: write expect
  });

  testWidgets('change star sign filter', (tester) async {
    await tester.tap(find.byKey(ValueKey('Star sign')));
    await tester.pumpAndSettle();
    expect(find.byType(CheckboxFilterPage), findsOneWidget);
    await tester.tap(find.text('Aries'));
    await tester.tap(find.text('Cancer'));
    await tester.tap(find.byType(MyBackButton));
    await tester.pumpAndSettle();
    expect(find.text('Aries, Cancer'), findsOneWidget);
  });

  testWidgets('reset star sign', (tester) async {
    await tester.tap(find.byKey(ValueKey('Star sign')));
    await tester.pumpAndSettle();
    expect(find.byType(CheckboxFilterPage), findsOneWidget);
    await tester.tap(find.text('Aries'));
    await tester.tap(find.text('Cancer'));
    await tester.tap(find.byType(MyBackButton));
    await tester.pumpAndSettle();
    expect(find.text('Aries, Cancer'), findsNothing);
  });
}
