import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { randomBytes } from "crypto";
import { pageRank } from "./algorithms/pagerank";

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

// export const onMatch = functions.firestore
//   .document("useractions/{uid}/actions/{actionId}")
//   .onCreate(async (snapshot, context) => {
//     const action = snapshot.data();
//     if (action != null) {
//       if (action.type == 2) {
//         const newMatchNotification: boolean = (
//           await db
//             .collection("userpreferences")
//             .doc(context.params.uid)
//             .get()
//         ).data()?.newMatchNotification;
//         if (newMatchNotification) {
//           const tokens: string[] = (
//             await db
//               .collection("users")
//               .doc(context.params.uid)
//               .collection("tokens")
//               .get()
//           ).docs.map(doc => doc.id);
//           const matchName: string = (
//             await db
//               .collection("users")
//               .doc(action.sender)
//               .get()
//           ).data()?.name;
//           if (matchName != null) {
//             const payload: admin.messaging.MessagingPayload = {
//               notification: {
//                 title: "Congratulations!",
//                 body: `${matchName} liked you too!`,
//                 clickAction: "FLUTTER_NOTIFICATION_CLICK"
//               }
//               // data: {
//               //     type: "newMatch",
//               //     uid: action.sender
//               // }
//             };
//             return fcm.sendToDevice(tokens, payload);
//           }
//         }
//       }
//     }
//     throw Error();
//   });

export const onMatch = functions.firestore
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

export const onMessage = functions.firestore
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

interface SuggestionGoneThrough {
  uid: string;
  liked: boolean;
  similarityScore: number;
}

export const updatePopularityScores = functions.firestore
  .document(
    "thisdocdoesnotexist/{andwillneverbecreated}/butthisfunctionwillbecalledmanually/thequickbrownfoxjumpsoverthelazydog"
  )
  .onCreate(async (snapshot, context) => {
    let users: string[] = [];
    let likedGraph: Array<Array<number>> = [];
    let userDocs: FirebaseFirestore.QueryDocumentSnapshot<
      FirebaseFirestore.DocumentData
    >[] = (await db.collection("users").get()).docs;
    userDocs.forEach((userDoc) => users.push(userDoc.id));
    userDocs.forEach((userDoc) => {
      let userLiked: number[] = [];
      userDoc
        .data()
        ["suggestionsGoneThrough"].forEach(
          (suggestion: SuggestionGoneThrough) => {
            if (suggestion.liked) {
              let userIndex: number = users.indexOf(suggestion.uid);
              if (userIndex != -1) userLiked.push(userIndex);
              else
                console.log(
                  `Invalid user: ${suggestion.uid} liked by ${userDoc.id}`
                );
            }
          }
        );
      likedGraph.push(userLiked);
    });

    console.log(likedGraph);

    let userPopularityScores: number[] = pageRank(likedGraph);

    if (userPopularityScores.length != users.length)
      throw Error("pagerank returned a different amount of users");

    let averagePopularityScore: number =
      userPopularityScores.reduce((val1, val2) => val1 + val2) /
      userPopularityScores.length;

    for (let i: number = 0; i < users.length; i++) {
      db.collection("users")
        .doc(users[i])
        .update({
          popularityScore:
            userPopularityScores[i] * (100 / averagePopularityScore),
        });
    }
  });

export const onBlockUser = functions.firestore
  .document("userblocked/{uid}/blocked/{blockedUid}")
  .onCreate(async (snapshot, context) => {
    db.collection("users")
      .doc(context.params.blockedUid)
      .update({ blockedScore: FirebaseFirestore.FieldValue.increment(1) });
  });

export const onUnblockUser = functions.firestore
  .document("userblocked/{uid}/blocked/{blockedUid}")
  .onDelete(async (snapshot, context) => {
    db.collection("users")
      .doc(context.params.blockedUid)
      .update({ blockedScore: FirebaseFirestore.FieldValue.increment(-1) });
  });

export const generateTestAccounts = functions.firestore
  .document("haoenutaoheusahoesuhoaeu/haoseunoaeua/aoeuatohuao/aoethutnsahous")
  .onCreate(async (snapshot, context) => {
    /*
     * provide these fields in snapshot.data:
     * - num (number of users)
     * - birthdayYearMin
     * - birthdayYearMax
     * - gender
     */

    // let data: FirebaseFirestore.DocumentData | undefined = snapshot.data();
    // if (data == undefined) {
    //   console.log(
    //     "No data. Provide the number of test accounts to generate and range of the year of birth"
    //   );
    //   return;
    // }
    let data = {
      num: 50,
      birthdayYearMin: 2004,
      birthdayYearMax: 2006,
      gender: 0,
    };
    let num: number = data.num;
    let birthdayYearMin: number = data.birthdayYearMin;
    let birthdayYearMax: number = data.birthdayYearMax;

    for (let _: number = 0; _ < num; ++_) {
      let username: string = randomBytes(10).toString("hex");

      let userProperties: admin.auth.CreateRequest = {
        email: `${username}@example.com`,
        password: "123456",
      };
      let user: admin.auth.UserRecord = await admin
        .auth()
        .createUser(userProperties);

      let gender: number = data.gender ?? Math.floor(Math.random() * 2); // 2 possible genders
      let birthdayYear: number =
        birthdayYearMin +
        Math.floor(Math.random() * (birthdayYearMax - birthdayYearMin));
      let birthdayMonth: number = 1 + Math.floor(Math.random() * 12);
      let birthday: Date = new Date(birthdayYear, birthdayMonth, 1);

      db.collection("users")
        .doc(user.uid)
        .set({
          phoneNumber: "",
          username: username,
          name:
            `Fake ${gender == 0 ? "Man" : "Woman"} ` +
            `${username.substring(0, 5)}`,
          gender: gender,
          profileImageUrl: "", // TODO:
          aboutMe: "",
          birthday: admin.firestore.Timestamp.fromDate(birthday),
          interests: [],
          extraMedia: Array(9).fill(null),
          verified: Math.floor(Math.random() * 2) == 1,
          asleep: false,
          online: false,
          lastSeen: admin.firestore.Timestamp.fromMillis(Date.now()),
          popularityScore: 100,
          conversationalScore: 0,
          blockedScore: 0,
          showMeBoys: gender == 1,
          showMeGirls: gender == 0,
          ageRangeMin: 2020 - birthdayYear - 1, // FIXME:
          ageRangeMax: 2020 - birthdayYear + 1,
          newMatchNotification: false,
          messageNotification: false,
          blockUnknownMessages: false,
          readReceipts: Math.floor(Math.random() * 2) == 1,
          showInMostPopular: true,
          popularityHistory: {},
          totalWordsSent: 0,
          theme: 0,
          lastGeneratedSuggestionsTimestamp: 0,
          numRightSwiped: 0,
        });
    }
  });

export const createAccount = functions.firestore
  .document("/newusers/{uid}")
  .onCreate(async (snapshot, context) => {
    // temporary solution
    /* fields
     * - name
     * - username
     * - gender
     * - birthday
     */
    const uid: string = context.params.uid;
    const data = snapshot.data();
    if (data == undefined) {
      console.log("no data in document");
      return;
    }
    console.log(data.birthday);
    console.log(data.birthday.toDate());
    db.collection("users")
      .doc(uid)
      .set({
        phoneNumber: "",
        username: data.username ?? randomBytes(10).toString("hex"),
        name: data.name ?? "Unknown",
        gender: data.gender,
        profileImageUrl: "",
        aboutMe: "",
        birthday: data.birthday,
        interests: [],
        extraMedia: Array(9).fill(null),
        verified: false,
        asleep: false,
        online: false,
        lastSeen: admin.firestore.Timestamp.fromMillis(Date.now()),
        popularityScore: 100,
        conversationalScore: 0,
        blockedScore: 0,
        showMeBoys: data.gender == 1,
        showMeGirls: data.gender == 0,
        ageRangeMin: 2020 - data.birthday.toDate().getFullYear() - 1,
        ageRangeMax: 2020 - data.birthday.toDate().getFullYear() + 1,
        newMatchNotification: true,
        messageNotification: true,
        blockUnknownMessages: false,
        readReceipts: true,
        showInMostPopular: true,
        popularityHistory: {},
        totalWordsSent: 0,
        theme: 0,
        lastGeneratedSuggestionsTimestamp: 0,
        numRightSwiped: 0,
      });
    db.collection("usersuggestionsgonethrough")
      .doc(uid)
      .set({ suggestionsGoneThrough: [] });
  });

export const deleteTestAccounts = functions.firestore
  .document("htnsaeunahtoe/nsaeu/nashteu/ahseunseu")
  .onCreate(async (context, snapshot) => {
    (
      await db
        .collection("users")
        .where("name", ">=", "Fake")
        .where("name", "<=", "Fakf")
        .get()
    ).forEach((doc) => {
      const docData = doc.data();
      console.log(`name: ${docData["name"]}`);
      if (docData["name"].startsWith("Fake")) doc.ref.delete();
    });
  });

// export const updateDbSchema = functions.firestore // update from version 1 to 2 of the database schema
//   .document(
//     "thisdocdoesnotexist/{andwillneverbecreated}/butthisfunctionwillbecalledmanually/thequickbrownfoxjumpsoverthelazydog"
//   )
//   .onCreate(async context =>
//     (await db.collection("users").get()).forEach(async doc => {
//       let prefs = (
//         await db
//           .collection("userpreferences")
//           .doc(doc.id)
//           .get()
//       ).data();
//       if (prefs != undefined) await doc.ref.update(prefs);
//       else console.log("user has no preferences: " + doc.id);

//       let filters = (
//         await db
//           .collection("userfilters")
//           .doc(doc.id)
//           .get()
//       ).data();
//       if (filters != undefined)
//         await doc.ref.update({
//           showMeBoys: filters["showMeBoys"],
//           showMeGirls: filters["showMeGirls"],
//           ageRangeMin: filters["ageRangeMin"],
//           ageRangeMax: filters["ageRangeMax"]
//         });
//       else console.log("user has no filters: " + doc.id);

//       let personalInfo: FirebaseFirestore.DocumentSnapshot = await db
//         .collection("userpersonalinfo")
//         .doc(doc.id)
//         .get();
//       if (personalInfo.exists) {
//         await doc.ref.update(personalInfo.data() ?? {});
//       } else console.log("user has no personal info: " + doc.id);
//     })
//   );

// export const updateDbSchema2 = functions.firestore
//   .document(
//     "thisdocdoesnotexist/etc/aoeuhtnssnthueoa/nowisthetimeforallgoodmentocometotheaidoftheirparty"
//   )
//   .onCreate(async context => {
//     (await db.collection("users").get()).docs.forEach(userDoc => {
//       userDoc.ref.update({
//         popularityHistory: {},
//         suggestionsGoneThrough: [],
//         totalWordsSent: 0,
//         theme: 0,
//         lastGeneratedSuggestionsTimestamp: 0,
//         numRightSwiped: 0
//       });
//     });
//   });
