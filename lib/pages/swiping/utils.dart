import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/user_algorithm_data.dart';
import 'package:tundr/models/user_private_info.dart';
import 'package:tundr/store/user.dart';

Future<void> updateNumRightSwipedRemoveFromListAndGoneThrough(
  BuildContext context,
  String otherUid, {
  bool likedUser,
  bool isRespondedSuggestion,
}) async {
  final privateInfo = Provider.of<User>(context, listen: false).privateInfo;
  if (likedUser) privateInfo.numRightSwiped++;
  if (isRespondedSuggestion) {
    privateInfo.respondedSuggestions.remove(otherUid);
  } else {
    privateInfo.dailyGeneratedSuggestions.remove(otherUid);
  }
  await Provider.of<User>(context, listen: false).writeFields(
    [
      'numRightSwiped',
      isRespondedSuggestion
          ? 'respondedSuggestions'
          : 'dailyGeneratedSuggestions',
    ],
    UserPrivateInfo,
  );

  Provider.of<User>(context, listen: false)
      .algorithmData
      .suggestionsGoneThrough[otherUid] = likedUser;
  await Provider.of<User>(context, listen: false).writeFields(
    ['suggestionsGoneThrough'],
    UserAlgorithmData,
  );
}
