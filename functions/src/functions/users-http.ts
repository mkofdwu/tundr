// http calls from the flutter app
// all responses must be valid JSON, so all return values must be in the format {result: ...}
// which will be understood by the client

import * as functions from 'firebase-functions';
import { userProfilesRef, usersPrivateInfoRef } from '../constants';

export const phoneNumberExists = functions.https.onCall(
  async (data, _context) => {
    const privateInfoDocs = await usersPrivateInfoRef
      .where('phoneNumber', '==', data.phoneNumber)
      .limit(1)
      .get();
    return {
      result: privateInfoDocs.docs.length > 0,
    };
  }
);

const N_MOST_POPULAR = 10;

export const getMostPopular = functions.https.onCall(
  async (_data, _context) => {
    const userPrivateInfoDocs = (
      await usersPrivateInfoRef
        .where('settings.showInMostPopular', '==', true)
        .orderBy('popularityScore', 'desc')
        .limit(N_MOST_POPULAR)
        .get()
    ).docs;
    const popularUsers = [];
    for (const privateInfoDoc of userPrivateInfoDocs) {
      const uid = privateInfoDoc.id;
      popularUsers.push({
        profile: (await userProfilesRef.doc(uid).get()).data(),
        popularityScore: privateInfoDoc.data().popularityScore,
      });
    }
    return { result: popularUsers };
  }
);

export const isBlockedBy = functions.https.onCall(async (data, context) => {
  const uid = context.auth?.uid;
  const otherUid = data.otherUid;
  if (uid == null || otherUid == null)
    throw 'user is not authenticated or did not supply otherUid';
  const otherPrivateInfo = (
    await usersPrivateInfoRef.doc(otherUid).get()
  ).data();
  if (otherPrivateInfo == null) throw "could not get other user's private info";
  return {
    result: otherPrivateInfo['blocked'].includes(uid),
  };
});
