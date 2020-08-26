import * as functions from "firebase-functions";

import { db } from "../../constants";
import SuggestionGoneThrough from "../../models/suggestion-gone-through";
import pageRank from "../../algorithms/pagerank";

export default functions.firestore
  .document(
    "thisdocdoesnotexist/{andwillneverbecreated}/butthisfunctionwillbecalledmanually/thequickbrownfoxjumpsoverthelazydog"
  )
  .onCreate(async (snapshot, context) => {
    let users: string[] = [];
    let likedGraph: Array<Array<number>> = [];
    let userDocs: FirebaseFirestore.QueryDocumentSnapshot<
      FirebaseFirestore.DocumentData
    >[] = (await db.collection("users").get()).docs;
    userDocs.forEach((userDoc) => users.push(userDoc.id));
    userDocs.forEach((userDoc) => {
      let userLiked: number[] = [];
      userDoc
        .data()
        ["suggestionsGoneThrough"].forEach(
          (suggestion: SuggestionGoneThrough) => {
            if (suggestion.liked) {
              let userIndex: number = users.indexOf(suggestion.uid);
              if (userIndex != -1) userLiked.push(userIndex);
              else
                console.log(
                  `Invalid user: ${suggestion.uid} liked by ${userDoc.id}`
                );
            }
          }
        );
      likedGraph.push(userLiked);
    });

    console.log(likedGraph);

    let userPopularityScores: number[] = pageRank(likedGraph);

    if (userPopularityScores.length != users.length)
      throw Error("pagerank returned a different amount of users");

    let averagePopularityScore: number =
      userPopularityScores.reduce((val1, val2) => val1 + val2) /
      userPopularityScores.length;

    for (let i: number = 0; i < users.length; i++) {
      db.collection("users")
        .doc(users[i])
        .update({
          popularityScore:
            userPopularityScores[i] * (100 / averagePopularityScore),
        });
    }
  });
