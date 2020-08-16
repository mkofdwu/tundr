import "dart:math";

import 'package:tundr/models/user.dart';

double scoreSimilarity(num user1Score, num user2Score) {
  // using item-item collaborative filtering
}

double interestsSimilarityScore(
  Set<String> user1Interests,
  Set<String> user2Interests,
) {
  if (user1Interests.isEmpty && user2Interests.isEmpty) return 0;
  return user1Interests.intersection(user2Interests).length /
      user1Interests.union(user2Interests).length;
}

double userSimilarity(User user1, User user2) {
  // returns a number between 0 and 4 representing how similar the users are
  // based on popularity, conversational-ness, number of times blocked and interests
  return (scoreSimilarity(user1.popularityScore, user2.popularityScore) +
      interestsSimilarityScore(
        user1.interests.toSet(),
        user2.interests.toSet(),
      ));
}
