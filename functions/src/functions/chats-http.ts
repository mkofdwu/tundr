import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import {
  chatsRef,
  userProfilesRef,
  usersAlgorithmDataRef,
  usersPrivateInfoRef,
} from '../constants';

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
    // returns the chat id
    const uid = context.auth?.uid;
    if (uid == null) return { result: '' };
    // check if allowed to start conversation, respond with error if not allowed
    if (!(await _canTalkTo(data, context))) {
      return { result: '' };
    }

    // create chat with participants & messages (add the first message)
    const chatDoc = await chatsRef.add({
      participants: [uid, data.otherUid],
    });
    chatDoc.collection('messages').add({
      senderUid: uid,
      sentOn: admin.firestore.Timestamp.now(),
      readOn: null,
      referencedMessageId: null,
      text: data.message.text,
      mediaType: data.message.mediaType,
      mediaUrl: data.message.mediaUrl,
    });
    await usersPrivateInfoRef.doc(uid).collection('chats').doc(chatDoc.id).set({
      uid: data.otherUid,
      wallpaperUrl: '',
      lastRead: admin.firestore.Timestamp.now(),
      type: 1,
    });
    await usersPrivateInfoRef.doc(data.otherUid).update({
      unknownChats: admin.firestore.FieldValue.arrayUnion(chatDoc.id),
    });
    return { result: chatDoc.id };
  }
);

export const readOtherUsersMessages = functions.https.onCall(
  async (data, context) => {
    const otherUid = data.otherUid;
    const chatId = data.chatId;
    if (otherUid == null || chatId == null) return;
    const messageDocs = (
      await chatsRef
        .doc(chatId)
        .collection('messages')
        .where('senderUid', '==', otherUid)
        .where('readOn', '==', null)
        .get()
    ).docs;
    for (const doc of messageDocs) {
      await doc.ref.update({ readOn: admin.firestore.Timestamp.now() });
    }
    // // PAID using the != filter operator requires the firebase blaze plan (upgrading to node 10, es2018 & firebase-admin 9)
    // const uid = context.auth?.uid;
    // const chatId = data.chatId;
    // if (uid == null || chatId == null) return;
    // const messageDocs = (
    //   await chatsRef
    //     .doc(chatId)
    //     .collection('messages')
    //     .where('senderUid', '!=', uid)
    //     .where('readOn', '==', null)
    //     .get()
    // ).docs;
    // for (const doc of messageDocs) {
    //   await doc.ref.update({ readOn: admin.firestore.Timestamp.now() });
    // }
  }
);