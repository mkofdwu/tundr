import "dart:math";

import 'package:tundr/models/user.dart';

double scoreSimilarity(num user1Score, num user2Score) {
  // returns a number between 0 and 1 representing how similar the numbers are
  // found this solution on https://math.stackexchange.com/questions/1481401/how-to-compute-similarity-between-two-numbers.
  // much simpler and seems to work
  assert(user1Score >= 0);
  assert(user2Score >= 0);
  if (user1Score == 0 && user2Score == 0) return 1;
  return min(user1Score, user2Score) / max(user1Score, user2Score);
}

double interestsSimilarityScore(
  Set<String> user1Interests,
  Set<String> user2Interests,
) {
  // returns a number between 0 and 1 representing how similar the interests are
  final int numSharedInterests =
      user1Interests.intersection(user2Interests).length;
  if (numSharedInterests == 0) return 0;
  return (numSharedInterests / user1Interests.length) *
      (numSharedInterests / user2Interests.length);
}

double interestsSimilarityScore2(
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
      scoreSimilarity(user1.conversationalScore, user2.conversationalScore) +
      scoreSimilarity(user1.blockedScore, user2.blockedScore) +
      interestsSimilarityScore2(
        user1.interests.toSet(),
        user2.interests.toSet(),
      ));
}

// double similarityScore({
//   User user1,
//   User user2,
//   double popularityScoreStdDeviation,
//   double conversationalScoreStdDeviation,
//   double blockedScoreStdDeviation,
// }) {
//   assert(popularityScoreStdDeviation != 0 &&
//       conversationalScoreStdDeviation != 0 &&
//       blockedScoreStdDeviation != 0);
//   return (1 -
//               (user1.popularityScore -
//                       user2
//                           .popularityScore) / // FIXME: this value may be negative
//                   popularityScoreStdDeviation)
//           .abs() +
//       (1 -
//               (user1.conversationalScore - user2.conversationalScore) /
//                   conversationalScoreStdDeviation)
//           .abs() +
//       (1 - (user1.blockedScore - user2.blockedScore) / blockedScoreStdDeviation)
//           .abs() +
//       interestsSimilarityScore(
//         user1.interests.toSet(),
//         user2.interests.toSet(),
//       );
// }
