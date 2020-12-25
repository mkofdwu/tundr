import admin = require('firebase-admin');

import { usersAlgorithmDataRef, usersPrivateInfoRef } from '../constants';
import pageRank from '../utils/pagerank';

const round2dp = (num: number) =>
  Math.round((num + Number.EPSILON) * 100) / 100;

export default async () => {
  let uids: string[] = [];
  let likedGraph: Array<Array<number>> = [];
  let algorithmDataDocs = (await usersAlgorithmDataRef.get()).docs;
  algorithmDataDocs.forEach((doc) => uids.push(doc.id));
  algorithmDataDocs.forEach((doc) => {
    const suggestionsGoneThrough = doc.data()['suggestionsGoneThrough'];
    const userLiked: number[] = [];
    for (const uid of Object.keys(suggestionsGoneThrough)) {
      if (suggestionsGoneThrough[uid]) {
        let userIndex: number = uids.indexOf(uid);
        if (userIndex != -1) userLiked.push(userIndex);
        else console.log(`Invalid user: ${uid} liked by ${doc.id}`);
      }
    }
    likedGraph.push(userLiked);
  });

  let userPopularityScores: number[] = pageRank(likedGraph);

  if (userPopularityScores.length != uids.length)
    throw 'pagerank returned a different amount of users';

  let averagePopularityScore: number =
    userPopularityScores.reduce((val1, val2) => val1 + val2) /
    userPopularityScores.length;

  for (let i: number = 0; i < uids.length; i++) {
    const updatedScore = round2dp(
      userPopularityScores[i] * (100 / averagePopularityScore)
    );
    usersPrivateInfoRef.doc(uids[i]).update({
      popularityScore: updatedScore,
      popularityHistory: admin.firestore.FieldValue.arrayUnion(
        Date.now() + ':' + updatedScore
      ),
    });
  }

  // NOTE: the average of all the scores generated should be 100 (with some margin of error)
};
