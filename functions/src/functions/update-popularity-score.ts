import admin = require('firebase-admin');
import * as functions from 'firebase-functions';

import { usersPrivateInfoRef } from '../constants';
import pageRank from '../utils/pagerank';

const round2dp = (num: number) =>
  Math.round((num + Number.EPSILON) * 100) / 100;

export default functions.firestore
  .document(
    'thisdocdoesnotexist/{andwillneverbecreated}/butthisfunctionwillbecalledmanually/thequickbrownfoxjumpsoverthelazydog'
  )
  .onCreate(async (snapshot, context) => {
    let users: string[] = [];
    let likedGraph: Array<Array<number>> = [];
    let userDocs = (await usersPrivateInfoRef.get()).docs;
    userDocs.forEach((userDoc) => users.push(userDoc.id));
    userDocs.forEach((userDoc) => {
      const suggestionsGoneThrough = userDoc.data()['suggestionsGoneThrough'];
      const userLiked: number[] = [];
      for (const uid of Object.keys(suggestionsGoneThrough)) {
        if (suggestionsGoneThrough[uid]) {
          let userIndex: number = users.indexOf(uid);
          if (userIndex != -1) userLiked.push(userIndex);
          else console.log(`Invalid user: ${uid} liked by ${userDoc.id}`);
        }
      }
      likedGraph.push(userLiked);
    });

    console.log(likedGraph);

    let userPopularityScores: number[] = pageRank(likedGraph);

    if (userPopularityScores.length != users.length)
      throw 'pagerank returned a different amount of users';

    let averagePopularityScore: number =
      userPopularityScores.reduce((val1, val2) => val1 + val2) /
      userPopularityScores.length;

    for (let i: number = 0; i < users.length; i++) {
      const updatedScore = round2dp(
        userPopularityScores[i] * (100 / averagePopularityScore)
      );
      usersPrivateInfoRef.doc(users[i]).update({
        popularityScore: updatedScore,
        popularityHistory: admin.firestore.FieldValue.arrayUnion(
          Date.now() + ':' + updatedScore
        ),
      });
    }

    // NOTE: the average of all the scores generated should be 100 (with some margin of error)
  });
