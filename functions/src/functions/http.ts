// http calls from the flutter app

import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

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

export const getMostPopular = functions.https.onCall(async (data, context) => {
  const userPrivateInfoDocs = (
    await admin
      .firestore()
      .collection('users_private_info')
      .where('settings.showInMostPopular', '==', true)
      .orderBy('popularityScore', 'desc')
      .limit(N_MOST_POPULAR)
      .get()
  ).docs;
  const userProfiles = [];
  for (const privateInfoDoc of userPrivateInfoDocs) {
    const uid = privateInfoDoc.id;
    userProfiles.push(
      (
        await admin.firestore().collection('user_profiles').doc(uid).get()
      ).data()
    );
  }
  return userProfiles;
});

export const startConversation = functions.https.onCall(
  async (data, context) => {
    // add to chats for current user
    // add to unknown chats for other user (if allowed)
    const uid = context.auth?.uid;
    if (uid == null) return;
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
  }
);
