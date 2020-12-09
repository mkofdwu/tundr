// requests concerning generated suggestions, (which suggestions to list), etc

import 'package:tundr/utils/call_https_function.dart';

class SuggestionsService {
  static Future<void> respondToSuggestion({
    String toUid,
    bool liked,
  }) =>
      callHttpsFunction(
          'respondToSuggestion', {'otherUid': toUid, 'liked': liked});

  static Future<void> undoSuggestionResponse(
          String userId, String suggestionUserUid) =>
      callHttpsFunction(
          'undoSuggestionResponse', {'otherUid': suggestionUserUid});

  static Future<void> matchWith(String otherUid) =>
      callHttpsFunction('matchWith', {'otherUid': otherUid});
}
