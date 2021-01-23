import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/auth.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Loads pictures within 7 seconds', (tester) async {
    await tester.tap(find.byKey(ValueKey('mostPopularTab')));
    await tester.waitFor(find.byType(CachedNetworkImage),
        timeout: Duration(seconds: 7));
  });
}
