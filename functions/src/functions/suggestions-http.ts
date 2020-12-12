import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import {
  chatsRef,
  fcm,
  interestsToGroupNo,
  numInterestGroups,
  userProfilesRef,
  usersAlgorithmDataRef,
  usersPrivateInfoRef,
} from '../constants';
import numberOfSimilarInterests from '../utils/num-similar-interests';

export const generateSuggestionsForNewUser = functions.https.onCall(
  async (_data, context) => {
    // FUTURE: ensure each user can only call this function once
    const uid = context.auth?.uid;
    if (uid == null) throw 'user is not authenticated';
    const profile = (await userProfilesRef.doc(uid).get()).data();
    const algorithmData = (await usersAlgorithmDataRef.doc(uid).get()).data();
    if (profile == null || algorithmData == null)
      throw 'could not get profile or algorithm data for user ' + uid;

    const showMeBoys = algorithmData['showMeBoys'];
    const showMeGirls = algorithmData['showMeGirls'];
    if (!showMeBoys && !showMeGirls) {
      console.log('no suggestions to generate');
      return;
    }
    let query;
    if (showMeBoys && showMeGirls) query = userProfilesRef;
    else if (showMeBoys) query = userProfilesRef.where('gender', '==', 0);
    else query = userProfilesRef.where('gender', '==', 1);

    const now = new Date();
    const minBirthday = new Date(
      now.getFullYear() - algorithmData['ageRangeMax'],
      now.getMonth(),
      now.getDate()
    );
    const maxBirthday = new Date(
      now.getFullYear() - algorithmData['ageRangeMin'],
      now.getMonth(),
      now.getDate()
    );
    const suitableUserDocs = (
      await query
        .where('birthday', '>', minBirthday) // this may be left out if firebase doesn't allow this many indexes
        .where('birthday', '<', maxBirthday)
        .get()
    ).docs;

    const userInterestsVector = new Array(numInterestGroups).fill(0);
    for (const interest of profile['interests']) {
      const groupNo = interestsToGroupNo[interest];
      ++userInterestsVector[groupNo];
    }

    const usersAndScores = []; // array with items [userId, score] pair

    // the newly created user should not have any filters, and should not have set their personal info
    for (const userDoc of suitableUserDocs) {
      const otherAlgorithmData = (
        await usersAlgorithmDataRef.doc(userDoc.id).get()
      ).data();
      if (otherAlgorithmData == null) continue;
      if (otherAlgorithmData['asleep']) continue;
      const otherProfile = userDoc.data();
      if (
        (Date.now() - profile['birthday']) / 31536000000 <
          otherProfile['ageRangeMin'] ||
        (Date.now() - profile['birthday']) / 31536000000 >
          otherProfile['ageRangeMax']
      )
        continue;

      const otherInterestsVector = new Array(numInterestGroups).fill(0);
      for (const interest of otherProfile['interests']) {
        const groupNo = interestsToGroupNo[interest];
        ++otherInterestsVector[groupNo];
      }
      const similarityScore = numberOfSimilarInterests(
        userInterestsVector,
        otherInterestsVector
      );
      usersAndScores.push([userDoc.id, similarityScore]);
    }

    const suggestionUserIds = usersAndScores
      .sort(
        (userAndScore1, userAndScore2) =>
          <number>userAndScore2[1] - <number>userAndScore1[1]
      )
      .slice(0, 10)
      .map((userAndScore) => userAndScore[0]);
    await usersPrivateInfoRef
      .doc(uid)
      .update({ dailyGeneratedSuggestions: suggestionUserIds });
  }
);

export const respondToSuggestion = functions.https.onCall(
  async (data, context) => {
    const uid = context.auth?.uid;
    const otherUid = data.otherUid;
    const liked = data.liked;
    if (uid == null || otherUid == null || typeof liked !== 'boolean') return;
    await usersPrivateInfoRef
      .doc(otherUid)
      .set({ respondedSuggestions: { [uid]: liked } }, { merge: true });
  }
);

export const undoSuggestionResponse = functions.https.onCall(
  async (data, context) => {
    const uid = context.auth?.uid;
    const otherUid = data.otherUid;
    if (uid == null || otherUid == null) return;
    await usersPrivateInfoRef.doc(otherUid).set(
      {
        respondedSuggestions: { [uid]: admin.firestore.FieldValue.delete() },
      },
      { merge: true }
    );
  }
);

export const matchWith = functions.https.onCall(async (data, context) => {
  const uid = context.auth?.uid;
  const otherUid = data.otherUid;
  if (uid == null || otherUid == null) return;

  // check if both users have indeed liked each other
  const privateInfo = (await usersPrivateInfoRef.doc(uid).get()).data();
  const otherPrivateInfo = (
    await usersPrivateInfoRef.doc(otherUid).get()
  ).data();
  if (privateInfo == null || otherPrivateInfo == null) return;
  if (
    // both should be true (suggestionsGoneThrough is a map in the format {uid: liked})
    !privateInfo['suggestionsGoneThrough'][otherUid] ||
    !otherPrivateInfo['suggestionsGoneThrough'][uid]
  )
    return;

  // save matches - create chats
  const chatDoc = await chatsRef.add({
    participants: [uid, otherUid],
  });
  await usersPrivateInfoRef.doc(uid).collection('chats').doc(chatDoc.id).set({
    uid: otherUid,
    wallpaperUrl: '',
    lastReadMessageId: null,
    type: 1, // chattype.newmatch
  });
  await usersPrivateInfoRef
    .doc(otherUid)
    .collection('chats')
    .doc(chatDoc.id)
    .set({
      uid: uid,
      wallpaperUrl: '',
      lastReadMessageId: null,
      type: 1, // chattype.newmatch
    });

  // send notification to other user (if he / she so desires)
  if (otherPrivateInfo['settings']['newMatchNotification']) {
    const tokens: string[] = (
      await usersPrivateInfoRef.doc(otherUid).collection('tokens').get()
    ).docs.map((doc) => doc.id);
    if (tokens.length == 0) return;
    const userProfile = (await userProfilesRef.doc(uid).get()).data();
    if (userProfile == null)
      throw `user with uid ${uid} initiated match but seems to have disappeared`;
    const matchName: string = userProfile['name'];
    if (matchName == null) throw 'user exists but data() returned undefined';
    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'Congratulations',
        body: `${matchName} liked you too!`,
        clickAction: 'FLUTTER_NOTIFICATION_CLICK',
      },
      data: {
        type: 'newMatch',
        uid: uid,
      },
    };
    return fcm.sendToDevice(tokens, payload);
  }
  return;
});
