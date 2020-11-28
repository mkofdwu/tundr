import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

import { fcm, userProfilesRef, usersPrivateInfoRef } from '../constants';

export default functions.firestore
  .document('usermatches/{uid}/matches/{matchUid}')
  .onCreate(async (snapshot, context) => {
    // TODO FIXME
    const userPrivateInfo = (
      await usersPrivateInfoRef.doc(context.params.uid).get()
    ).data();
    if (userPrivateInfo == null)
      throw new Error('user exists but data() returned undefined');

    if (userPrivateInfo['settings']['newMatchNotification']) {
      const tokens: string[] = (
        await usersPrivateInfoRef
          .doc(context.params.uid)
          .collection('tokens')
          .get()
      ).docs.map((doc) => doc.id);

      const otherUserProfile = (
        await userProfilesRef.doc(context.params.matchUid).get()
      ).data();

      if (otherUserProfile == null)
        throw new Error(
          `user with uid ${context.params.matchUid} initiated match but seems to have disappeared`
        );

      const matchName: string = otherUserProfile['name'];
      if (matchName == null)
        throw new Error('user exists but data() returned undefined');

      const payload: admin.messaging.MessagingPayload = {
        notification: {
          title: 'Congratulations!',
          body: `${matchName} liked you too!`,
          clickAction: 'FLUTTER_NOTIFICATION_CLICK',
        },
        // data: {
        //     type: "newMatch",
        //     uid: action.sender
        // }
      };
      return fcm.sendToDevice(tokens, payload);
    }
    throw Error();
  });
