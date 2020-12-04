// http calls from the flutter app
// all responses must be valid JSON, so all return values must be in the format {result: ...}
// which will be understood by the client

import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import {
  chatsRef,
  fcm,
  userProfilesRef,
  usersAlgorithmDataRef,
  usersPrivateInfoRef,
} from '../constants';

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

export const checkReadReceipts = functions.https.onCall(
  async (data, context) => {
    // returns whether read receipts will be enabled for the chat between the two users
    const uid = context.auth?.uid;
    if (uid == null) return;
    const userDoc = await usersPrivateInfoRef.doc(uid).get();
    const otherUserDoc = await usersPrivateInfoRef.doc(data.otherUid).get();
    const userPrivateInfo = userDoc.data();
    const otherUserPrivateInfo = otherUserDoc.data();
    if (userPrivateInfo == null || otherUserPrivateInfo == null)
      return { result: null };
    return {
      result:
        userPrivateInfo.settings.readReceipts &&
        otherUserPrivateInfo.settings.readReceipts,
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

const _canTalkTo = async (
  data: any,
  context: functions.https.CallableContext
) => {
  const uid = context.auth?.uid;
  if (uid == null) return false;
  const otherUid = data.otherUid;
  // check if chat already exists
  const snapshot = await usersPrivateInfoRef
    .doc(uid)
    .collection('chats')
    .where('uid', '==', otherUid)
    .limit(1)
    .get();
  if (snapshot.docs.length !== 0) return true;
  // check if user blocks unknown messages
  const otherUserPrivateInfo = (
    await usersPrivateInfoRef.doc(otherUid).get()
  ).data();
  if (otherUserPrivateInfo == null) return false;
  if (otherUserPrivateInfo['settings']['blockUnknownMessages']) return false;
  // check if user is blocked
  if (otherUserPrivateInfo['blocked'].includes(uid)) return false;

  // check if sexualities are appropriate
  const userProfile = (await userProfilesRef.doc(uid).get()).data();
  const userAlgorithmData = (await usersAlgorithmDataRef.doc(uid).get()).data();
  const otherUserProfile = (await userProfilesRef.doc(otherUid).get()).data();
  const otherUserAlgorithmData = (
    await usersAlgorithmDataRef.doc(otherUid).get()
  ).data();
  if (
    userProfile == null ||
    userAlgorithmData == null ||
    otherUserProfile == null ||
    otherUserAlgorithmData == null
  )
    return false;
  if (userProfile['gender'] === 0 && !otherUserAlgorithmData['showMeBoys'])
    return false;
  if (userProfile['gender'] === 1 && !otherUserAlgorithmData['showMeGirls'])
    return false;
  if (otherUserProfile['gender'] === 0 && !userAlgorithmData['showMeBoys'])
    return false;
  if (otherUserProfile['gender'] === 1 && !userAlgorithmData['showMeGirls'])
    return false;

  return true;
};

export const canTalkTo = functions.https.onCall(async (data, context) => {
  return {
    result: await _canTalkTo(data, context),
  };
});

export const startConversation = functions.https.onCall(
  async (data, context) => {
    // add to chats for current user
    // add to unknown chats for other user (if allowed)
    const uid = context.auth?.uid;
    if (uid == null) return { result: false };
    // check if allowed to start conversation, respond with error if not allowed
    if (!(await _canTalkTo(data, context))) {
      return { result: false };
    }

    // create chat with participants & messages (add the first message)
    const chatDoc = await chatsRef.add({
      participants: [uid, data.otherUid],
    });
    chatDoc.collection('messages').add({
      senderUid: uid,
      sentTimestamp: admin.firestore.Timestamp.now(),
      readTimestamp: null,
      referencedMessageId: null,
      text: data.message.text,
      mediaType: data.message.mediaType,
      mediaUrl: data.message.mediaUrl,
    });
    await usersPrivateInfoRef.doc(uid).collection('chats').doc(chatDoc.id).set({
      uid: data.otherUid,
      wallpaperUrl: '',
      lastReadTimestamp: admin.firestore.Timestamp.now(),
      type: 1,
    });
    await usersPrivateInfoRef.doc(data.otherUid).update({
      unknownChats: admin.firestore.FieldValue.arrayUnion(chatDoc.id),
    });
    return { result: true };
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

  // save matches
  await usersPrivateInfoRef.doc(uid).update({
    matches: admin.firestore.FieldValue.arrayUnion(otherUid),
  });
  await usersPrivateInfoRef.doc(otherUid).update({
    matches: admin.firestore.FieldValue.arrayUnion(uid),
  });

  // send notification to other user (if he / she so desires)
  if (otherPrivateInfo['settings']['newMatchNotification']) {
    const tokens: string[] = (
      await usersPrivateInfoRef.doc(otherUid).collection('tokens').get()
    ).docs.map((doc) => doc.id);
    const userProfile = (await userProfilesRef.doc(uid).get()).data();
    if (userProfile == null)
      throw `user with uid ${uid} initiated match but seems to have disappeared`;
    const matchName: string = userProfile['name'];
    if (matchName == null) throw 'user exists but data() returned undefined';
    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'Congratulations!',
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
