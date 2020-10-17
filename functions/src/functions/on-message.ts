import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

import { db, fcm } from "../constants";

export default functions.firestore
  .document("chats/{chatId}/messages/{messageId}")
  .onCreate(async (snapshot, context) => {
    const participants: FirebaseFirestore.QuerySnapshot = await db
      .collection("chats")
      .doc(context.params.chatId)
      .collection("participants")
      .get();
    const message: FirebaseFirestore.DocumentData | undefined = snapshot.data();
    if (message == undefined)
      throw new Error("message created but mysteriously disappeared");

    const senderUserData: FirebaseFirestore.DocumentData | undefined = (
      await db.collection("users").doc(message.senderUid).get()
    ).data();

    let senderName: string;
    // user sent a message but somehow he doesn't exist
    if (senderUserData == undefined) senderName = "<Deleted>";
    else senderName = senderUserData.name;

    const tokens: string[] = [];
    participants.docs.forEach(async (doc) => {
      if (doc.id == message.senderUid) return; // don't send the notification to the original sender
      tokens.push(
        ...(
          await db.collection("users").doc(doc.id).collection("tokens").get()
        ).docs.map((doc) => doc.id)
      );
    });

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: senderName,
        body: message.text,
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
      // data: {
      //     type: "newMessage",
      //     id: message.id
      // }
    };
    return fcm.sendToDevice(tokens, payload);
  });
