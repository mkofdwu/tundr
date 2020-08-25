import * as functions from "firebase-functions";

import { db } from "../../constants";

export default functions.firestore
  .document(
    "thisdocdoesnotexist/{andwillneverbecreated}/butthisfunctionwillbecalledmanually/thequickbrownfoxjumpsoverthelazydog"
  )
  .onCreate(async (snapshot, context) => {
    (await db.collection("users").get()).forEach((userDoc) => {
      userDoc.data();
      // TODO: reset numRightSwiped to 0
    });
  });
