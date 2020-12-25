import admin = require('firebase-admin');
import {
  chatsRef,
  userProfilesRef,
  usersAlgorithmDataRef,
  usersPrivateInfoRef,
  userStatusesRef,
} from './constants';

export const migrateUserChatLastRead = async () => {
  const privateInfoDocs = (await usersPrivateInfoRef.get()).docs;
  for (const privateInfoDoc of privateInfoDocs) {
    const userChatDocs = (await privateInfoDoc.ref.collection('chats').get())
      .docs;
    for (const userChatDoc of userChatDocs) {
      await userChatDoc.ref.update({
        lastRead: admin.firestore.FieldValue.delete(),
        lastReadMessageId: null,
      });
    }
  }
};

export const migrateSuggestionsGoneThrough = async () => {
  const privateInfoDocs = (await usersPrivateInfoRef.get()).docs;
  for (const privateInfoDoc of privateInfoDocs) {
    const suggestionsGoneThrough = privateInfoDoc.data()[
      'suggestionsGoneThrough'
    ];
    await privateInfoDoc.ref.update({
      suggestionsGoneThrough: admin.firestore.FieldValue.delete(),
    });
    await usersAlgorithmDataRef.doc(privateInfoDoc.id).update({
      suggestionsGoneThrough,
    });
  }
};

export const migrateChatTyping = async () => {
  const chatDocs = (await chatsRef.get()).docs;
  for (const chatDoc of chatDocs) {
    await chatDoc.ref.update({
      typing: [],
    });
  }
};

export const removeIncompleteUsers = async () => {
  const allIds: Set<string> = new Set();
  for (const doc of (await userProfilesRef.get()).docs) {
    allIds.add(doc.id);
  }
  for (const doc of (await usersPrivateInfoRef.get()).docs) {
    allIds.add(doc.id);
  }
  for (const doc of (await usersAlgorithmDataRef.get()).docs) {
    allIds.add(doc.id);
  }
  for (const doc of (await userStatusesRef.get()).docs) {
    allIds.add(doc.id);
  }
  for (const uid of allIds) {
    if (
      !(await userProfilesRef.doc(uid).get()).exists ||
      !(await usersPrivateInfoRef.doc(uid).get()).exists ||
      !(await usersAlgorithmDataRef.doc(uid).get()).exists ||
      !(await userStatusesRef.doc(uid).get()).exists
    ) {
      await userProfilesRef.doc(uid).delete();
      await usersPrivateInfoRef.doc(uid).delete();
      await usersAlgorithmDataRef.doc(uid).delete();
      await userStatusesRef.doc(uid).delete();
    }
  }
};
