import admin = require('firebase-admin');
import { usersAlgorithmDataRef, usersPrivateInfoRef } from './constants';

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
