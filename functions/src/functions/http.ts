// http calls from the flutter app

import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

export const phoneNumberExists = functions.https.onCall(
  async (data, _context) => {
    const privateInfoDocs = await admin
      .firestore()
      .collection('users_private_info')
      .where('phoneNumber', '==', data.phoneNumber)
      .limit(1)
      .get();
    return privateInfoDocs.docs.length > 0;
  }
);

export const checkReadReceipts = functions.https.onCall(
  async (data, context) => {
    // returns whether read receipts will be enabled for the chat between the two users
    const uid = context.auth?.uid;
    if (uid == null) return;
    const userDoc = await admin
      .firestore()
      .collection('users_private_info')
      .doc(uid)
      .get();
    const otherUserDoc = await admin
      .firestore()
      .collection('users_private_info')
      .doc(data.otherUid)
      .get();
    const userPrivateInfo = userDoc.data();
    const otherUserPrivateInfo = otherUserDoc.data();
    if (userPrivateInfo == null || otherUserPrivateInfo == null) return;
    return (
      userPrivateInfo.settings.readReceipts &&
      otherUserPrivateInfo.settings.readReceipts
    );
  }
);

const N_MOST_POPULAR = 10;

export const getMostPopular = functions.https.onCall(
  async (_data, _context) => {
    const userPrivateInfoDocs = (
      await admin
        .firestore()
        .collection('users_private_info')
        .where('settings.showInMostPopular', '==', true)
        .orderBy('popularityScore', 'desc')
        .limit(N_MOST_POPULAR)
        .get()
    ).docs;
    const popularUsers = [];
    for (const privateInfoDoc of userPrivateInfoDocs) {
      const uid = privateInfoDoc.id;
      popularUsers.push({
        profile: (
          await admin.firestore().collection('user_profiles').doc(uid).get()
        ).data(),
        popularityScore: privateInfoDoc.data().popularityScore,
      });
    }
    return popularUsers;
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
  const snapshot = await admin
    .firestore()
    .collection('users_private_info')
    .doc(uid)
    .collection('chats')
    .where('uid', '==', otherUid)
    .limit(1)
    .get();
  if (snapshot.docs.length !== 0) return true;
  // check if user blocks unknown messages
  const otherUser = (
    await admin.firestore().collection('users_private_info').doc(otherUid).get()
  ).data();
  if (otherUser == null) return false;
  if (otherUser['settings']['blockUnknownMessages']) return false;
  // check if user is blocked
  if (otherUser['blocked'].contains(uid)) return false;
  return true;
};

export const canTalkTo = functions.https.onCall(async (data, context) => {
  const result = await _canTalkTo(data, context);
  return result;
});

export const startConversation = functions.https.onCall(
  async (data, context) => {
    // add to chats for current user
    // add to unknown chats for other user (if allowed)
    const uid = context.auth?.uid;
    if (uid == null) return false;
    // check if allowed to start conversation, respond with error if not allowed
    if (!(await _canTalkTo(data, context))) {
      return false;
    }

    // create chat with participants & messages (add the first message)
    const chatDoc = await admin
      .firestore()
      .collection('chats')
      .add({
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
    await admin
      .firestore()
      .collection('users_private_info')
      .doc(uid)
      .collection('chats')
      .doc(chatDoc.id)
      .set({
        uid: data.otherUid,
        wallpaperUrl: '',
        lastReadTimestamp: admin.firestore.Timestamp.now(),
        type: 1,
      });
    await admin
      .firestore()
      .collection('users_private_info')
      .doc(data.otherUid)
      .update({
        unknownChats: admin.firestore.FieldValue.arrayUnion(chatDoc.id),
      });
    return true;
  }
);
