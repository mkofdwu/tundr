import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

import { db, fcm } from "../../constants";

export default functions.firestore
  .document("usermatches/{uid}/matches/{matchUid}")
  .onCreate(async (snapshot, context) => {
    const user: FirebaseFirestore.DocumentSnapshot = await db
      .collection("users")
      .doc(context.params.uid)
      .get();
    if (!user.exists) return;

    const userData: FirebaseFirestore.DocumentData | undefined = user.data();
    if (userData == undefined)
      throw new Error("user exists but data() returned undefined");

    if (userData.newMatchNotification) {
      const tokens: string[] = (
        await db
          .collection("users")
          .doc(context.params.uid)
          .collection("tokens")
          .get()
      ).docs.map((doc) => doc.id);

      const otherUser: FirebaseFirestore.DocumentSnapshot = await db
        .collection("users")
        .doc(context.params.matchUid)
        .get();

      if (!otherUser.exists)
        throw new Error(
          `user with uid ${context.params.matchUid} initiated match but seems to have disappeared`
        );

      const matchName: string = otherUser.data()?.name;
      if (matchName == null)
        throw new Error("user exists but data() returned undefined");

      const payload: admin.messaging.MessagingPayload = {
        notification: {
          title: "Congratulations!",
          body: `${matchName} liked you too!`,
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
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
