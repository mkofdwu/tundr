// requests concerning generated suggestions, (which suggestions to list), etc

import 'package:cloud_functions/cloud_functions.dart';

class SuggestionsService {
  static Future<void> respondToSuggestion({
    String fromUid,
    String toUid,
    bool liked,
  }) async {
    await CloudFunctions.instance
        .getHttpsCallable(functionName: 'respondToSuggestion')
        .call({'otherUid': toUid, 'liked': liked});
  }

  static Future<void> undoSuggestionResponse(
      String userId, String suggestionUserUid) async {
    await CloudFunctions.instance
        .getHttpsCallable(functionName: 'undoSuggestionResponse')
        .call({'otherUid': suggestionUserUid});
  }

  static Future<void> match(String otherUid) async {
    await CloudFunctions.instance
        .getHttpsCallable(functionName: 'match')
        .call({'otherUid': otherUid});
  }
}
