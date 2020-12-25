import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import {
  chatsRef,
  userProfilesRef,
  usersAlgorithmDataRef,
  usersPrivateInfoRef,
} from '../constants';

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
    const otherUid = data.otherUid;
    const message = data.message;
    if (uid == null || otherUid == null || message == null)
      return { result: '' };
    // check if allowed to start conversation, respond with error if not allowed
    if (!(await _canTalkTo(data, context))) {
      return { result: null };
    }

    // create chat with participants & messages (add the first message)
    const chatDoc = await chatsRef.add({
      participants: [uid, otherUid],
      typing: [],
    });
    await chatDoc.collection('messages').add({
      senderUid: uid,
      sentOn: admin.firestore.Timestamp.now(),
      readOn: null,
      referencedMessageId: null,
      text: message.text,
      mediaType: message.mediaType,
      mediaUrl: message.mediaUrl,
    });
    await usersPrivateInfoRef.doc(uid).collection('chats').doc(chatDoc.id).set({
      uid: otherUid,
      wallpaperUrl: '',
      lastReadMessageId: null, // user is still in chat page
      type: 3, // chattype.normal
    });
    await usersPrivateInfoRef
      .doc(otherUid)
      .collection('chats')
      .doc(chatDoc.id)
      .set({
        uid: uid,
        wallpaperUrl: '',
        lastReadMessageId: null, // null means all messages have been read, no separator will be drawn
        type: 4, // chattype.unknown
      });
    return { result: chatDoc.id };
  }
);
