import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/auth.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Loads pictures within 6 seconds', (tester) async {
    await startApp(tester);
    await tester.tap(find.byKey(ValueKey('mostPopularTab')));
    await tester.pump(Duration(seconds: 6));
    expect(find.byType(CachedNetworkImage), findsWidgets);
  });
}