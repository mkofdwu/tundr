import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tundr/constants/enums/filtermethod.dart';
import 'package:tundr/constants/enums/gender.dart';
import 'package:tundr/constants/enums/personalinfotype.dart';
import 'package:tundr/constants/firebaseref.dart';
import 'package:tundr/models/filter.dart';
import 'package:tundr/models/suggestion-gone-through.dart';
import 'package:tundr/models/suggestion.dart';
import 'package:tundr/models/user.dart';
import 'package:tundr/utils/algorithms/similarity-score.dart';

class SuggestionsService {
  static Query secondaryFilterUsers(dynamic users, Filter filter) {
    // users: either DocumentReference (usersRef) or Query
    print(
        "filtering with: ${filter.field.name}, type ${filter.field.type}, options ${filter.field.options}");
    if (filter.options == null) return users;
    switch (filter.field.type) {
      case PersonalInfoType.numInput:
      case PersonalInfoType.slider:
        return users.where(
          filter.field.name,
          isGreaterThanOrEqualTo: filter.options.first,
          isLessThanOrEqualTo: filter.options.last,
        );
      case PersonalInfoType.radioGroup:
      case PersonalInfoType.textInput:
        return users.where(filter.field.name, whereIn: filter.options);
      case PersonalInfoType.textList:
        switch (filter.method) {
          case FilterMethod.none:
            return users;
          case FilterMethod.ifContainsAll:
            return users.where(
              filter.field.name,
              arrayContains: filter.options,
            );
          case FilterMethod.ifContainsAny:
            return users.where(
              filter.field.name,
              arrayContainsAny: filter.options,
            );
          default:
            throw Exception("Invalid filter method: ${filter.method}");
        }
        break;
      default:
        throw Exception("Invalid personal info type: ${filter.method}");
    }
  }

  static Future<bool> otherUserFiltersAllow(User user, User otherUser) async {
    // final Map<String, dynamic> otherUserFilters =
    //     (await userFiltersRef.document(otherUid).get()).data;
    if (user.gender == Gender.male && !otherUser.showMeBoys) {
      return false;
    }
    if (user.gender == Gender.female && !otherUser.showMeGirls) {
      return false;
    }
    if (user.ageInYears > otherUser.ageRangeMax ||
        otherUser.ageRangeMin > user.ageInYears) {
      return false;
    }
    return true;
  }

  static Future<Query> filterUsers({
    User user,
  }) async {
    final now = DateTime.now();
    Query usersQuery = usersRef.where("asleep", isEqualTo: false).where(
      "gender",
      whereIn: [
        if (user.showMeBoys) 0,
        if (user.showMeGirls) 1,
      ],
    ).where(
      "birthday",
      isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(
        now.year - user.ageRangeMax,
        now.month,
        now.day,
      )),
      isLessThanOrEqualTo: Timestamp.fromDate(DateTime(
        now.year - user.ageRangeMin,
        now.month,
        now.day,
      )),
    );

    (await getUserFilters(user.uid)).map((filter) {
      usersQuery = secondaryFilterUsers(usersQuery, filter);
    });
    return usersQuery;
  }

  static Future<List<Suggestion>> generateSuggestions({
    User user,
    int n,
    List<String> storedSuggestionUids,
    List<SuggestionGoneThrough> suggestionsGoneThrough,
  }) async {
    final Query usersQuery = await filterUsers(user: user);

    final Query orderedByPopScoreHalf = usersQuery
        .orderBy("popularityScore")
        .limit(n); // increased to n, since some users will be filtered
    final List<DocumentSnapshot> orderedByPopScoreDocs =
        (await orderedByPopScoreHalf.getDocuments()).documents +
            (await orderedByPopScoreHalf
                    .startAt([user.popularityScore]).getDocuments())
                .documents;

    final List<String> suggestionUids = [];
    final List<Suggestion> newSuggestions = [];
    final List<String> uidsGoneThrough = storedSuggestionUids +
        suggestionsGoneThrough.map((suggestion) => suggestion.uid).toList();

    // final now = DateTime.now();

    orderedByPopScoreDocs.forEach((doc) {
      if (suggestionUids.contains(doc.documentID) ||
          uidsGoneThrough.contains(doc.documentID) ||
          doc.documentID == user.uid) return;

      // final DateTime birthday = doc.data["birthday"].toDate();

      // if (birthday.isBefore(DateTime(
      //       now.year - user.ageRangeMax,
      //       now.month,
      //       now.day,
      //     )) ||
      //     birthday.isAfter(DateTime(
      //       now.year - user.ageRangeMin,
      //       now.month,
      //       now.day,
      //     ))) return;

      suggestionUids.add(doc.documentID);

      final User otherUser = User.fromDoc(doc);
      newSuggestions.add(Suggestion(
        user: otherUser,
        liked: null,
        similarityScore: userSimilarity(user, otherUser),
      ));
    });

    newSuggestions.sort((suggestion1, suggestion2) => suggestion2
        .similarityScore
        .compareTo(suggestion1.similarityScore)); // sort descending

    return newSuggestions.sublist(0, min(n, newSuggestions.length));
  }
}
