import * as functions from "firebase-functions";

import generateSuggestions from "../algorithms/generate-suggestions";
import { db } from "../constants";

export default functions.firestore
  .document(
    "thisdocdoesnotexist/{andwillneverbecreated}/butthisfunctionwillbecalledmanually/thequickbrownfoxjumpsoverthelazydog"
  )
  .onCreate(async (snapshot, context) => {
    const userDocsById: Map<
      string,
      FirebaseFirestore.QueryDocumentSnapshot
    > = new Map();
    const users: Array<FirebaseFirestore.DocumentData> = [];
    (await db.collection("users").get()).docs.forEach((userDoc) => {
      userDocsById.set(userDoc.id, userDoc);
      users.push(userDoc.data());
    });

    const uidToSuggestions = generateSuggestions(users);
    for (const uid in uidToSuggestions) {
      userDocsById.get(uid)?.ref.update({
        generatedDailySuggestions: uidToSuggestions.get(uid),
      });
    }
  });
