// requests concerning generated suggestions, (which suggestions to list), etc

import 'package:tundr/models/suggestion.dart';

class SuggestionsService {
  static Future<void> sendSuggestion({
    String fromUid,
    String toUid,
    bool liked,
    double similarityScore,
  }) {
    // add suggestion to list of user responded suggestions
    return userSuggestionsRef
        .doc(toUid)
        .collection('suggestions')
        .doc(fromUid)
        .setData({
      'liked': liked,
      'similarityScore': similarityScore,
    });
  }

  static Future<void> undoSentSuggestion(
      String userId, String suggestionUserUid) {
    return userSuggestionsRef
        .doc(suggestionUserUid)
        .collection('suggestions')
        .doc(userId)
        .delete();
  }

  static Future<void> match(String uid, String otherUid) {
    return Future.wait([
      userMatchesRef.doc(uid).collection('matches').doc(otherUid).setData({}),
      userMatchesRef.doc(otherUid).collection('matches').doc(uid).setData({}),
    ]);
  }
}
