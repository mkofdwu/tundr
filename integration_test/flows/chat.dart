import 'package:flutter_test/flutter_test.dart';
import 'package:tundr/enums/media_type.dart';

import 'package:tundr/pages/home.dart';

Future<void> startConversationCreatesChat(tester) async {
  expect(find.byType(HomePage), findsOneWidget);
}

Future<void> startConversationWithoutMessageDoesNotCreateChat(tester) async {}

Future<void> sendMessage(tester,
    {bool containsText = true,
    MediaType mediaType,
    bool referenceAMessage = false}) async {}

Future<void> blockUserAndDeleteChat(tester) async {}

Future<void> scrollToTopLoadsMoreMessages(tester) async {}

Future<void> clickReferencedMessage(tester) async {}

Future<void> dragMessageToQuote(tester) async {}

Future<void> changeWallpaper(tester) async {}

Future<void> checkChatTile(tester) async {
  // finds the chat tile in messages tab and ensures it contains valid content
  // throws an error if anything is wrong
}
