import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tundr/constants/values.dart';
import 'package:tundr/models/suggestion.dart';
import 'package:tundr/models/user.dart';
import 'package:tundr/repositories/current-user.dart';
import 'package:tundr/repositories/user-suggestions.dart';
import 'package:tundr/services/database-service.dart';

Future<void> _generateAndAddSuggestions(BuildContext context) async {
  final User user = Provider.of<CurrentUser>(context).user;

  user.lastGeneratedSuggestionsTimestamp =
      DateTime.now().millisecondsSinceEpoch;
  user.numRightSwiped = 0;
  DatabaseService.setUserFields(user.uid, {
    "lastGeneratedSuggestionsTimestamp": user.lastGeneratedSuggestionsTimestamp,
    "numRightSwiped": user.numRightSwiped,
  });

  final List<Suggestion> storedSuggestions =
      await DatabaseService.getUserSuggestions(user.uid);
  if (storedSuggestions.length >= numSuggestionsEveryTwoHours) {
    return;
  }

  final List<Suggestion> newSuggestions =
      await DatabaseService.generateSuggestions(
    user: user,
    n: numSuggestionsEveryTwoHours - storedSuggestions.length,
    storedSuggestionUids:
        storedSuggestions.map((suggestion) => suggestion.user.uid).toList(),
    suggestionsGoneThrough:
        await DatabaseService.getUserSuggestionsGoneThrough(user.uid),
  );

  Provider.of<UserSuggestions>(context).suggestions.addAll(newSuggestions);
  Provider.of<UserSuggestions>(context).suggestions.addAll(storedSuggestions);
  await DatabaseService.saveNewSuggestions(
    user.uid,
    newSuggestions,
  );
}

void loadUserSuggestions(BuildContext context) async {
  // load user suggestions
  Provider.of<UserSuggestions>(context).loading = true;

  if (Provider.of<CurrentUser>(context).user.lastGeneratedSuggestionsTimestamp +
          millisecondsInTwoHours <=
      DateTime.now().millisecondsSinceEpoch) {
    // add new suggestions every 2 hours
    await _generateAndAddSuggestions(context);
  } else {
    Provider.of<UserSuggestions>(context).suggestions.addAll(
          await DatabaseService.getUserSuggestions(
              Provider.of<CurrentUser>(context).user.uid),
        );
  }

  Provider.of<UserSuggestions>(context).loading = false;
}
