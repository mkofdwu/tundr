// requests concerning generated suggestions, (which suggestions to list), etc

import 'package:cloud_functions/cloud_functions.dart';

class SuggestionsService {
  static Future<void> respondToSuggestion({
    String fromUid,
    String toUid,
    bool liked,
  }) async {
    await FirebaseFunctions.instance
        .httpsCallable('respondToSuggestion')
        .call({'otherUid': toUid, 'liked': liked});
  }

  static Future<void> undoSuggestionResponse(
      String userId, String suggestionUserUid) async {
    await FirebaseFunctions.instance
        .httpsCallable('undoSuggestionResponse')
        .call({'otherUid': suggestionUserUid});
  }

  static Future<void> matchWith(String otherUid) async {
    await FirebaseFunctions.instance
        .httpsCallable('matchWith')
        .call({'otherUid': otherUid});
  }
}
