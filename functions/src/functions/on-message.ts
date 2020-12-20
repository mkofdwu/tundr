import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

import {
  chatsRef,
  fcm,
  userProfilesRef,
  usersPrivateInfoRef,
} from '../constants';

export default functions.firestore
  .document('chats/{chatId}/messages/{messageId}')
  .onCreate(async (snapshot, context) => {
    const chat = (await chatsRef.doc(context.params.chatId).get()).data();
    if (chat == null)
      throw 'could not find chat of id: ' + context.params.chatId;
    const participants = chat['participants'];
    const message = snapshot.data();
    if (message == null) throw 'message created but mysteriously disappeared';

    const sender = (
      await userProfilesRef.doc(message['senderUid']).get()
    ).data();
    if (sender == null)
      throw 'could not find message sender with uid: ' + message['senderUid'];

    const tokens: string[] = [];
    for (const uid of participants) {
      if (uid == message['senderUid']) return; // don't send the notification to the original sender
      tokens.push(
        ...(
          await usersPrivateInfoRef.doc(uid).collection('tokens').get()
        ).docs.map((doc) => doc.id)
      );
    }
    if (tokens.length == 0) return;

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: sender['name'],
        body: message['text'],
        clickAction: 'FLUTTER_NOTIFICATION_CLICK',
      },
      data: {
        type: 'newMessage',
        chatId: context.params.chatId,
      },
    };
    await fcm.sendToDevice(tokens, payload);
  });
