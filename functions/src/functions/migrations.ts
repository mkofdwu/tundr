import admin = require('firebase-admin');
import * as functions from 'firebase-functions';
import { usersPrivateInfoRef } from '../constants';

export const migrateUserChatLastRead = functions.firestore
  .document(
    'thisdocdoesnotexist/{andwillneverbecreated}/butthisfunctionwillbecalledmanually/thequickbrownfoxjumpsoverthelazydog'
  )
  .onCreate(async (snapshot, context) => {
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
  });
