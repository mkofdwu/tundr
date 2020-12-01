import * as functions from 'firebase-functions';

import generateSuggestions from '../algorithms/generate-suggestions';
import {
  userProfilesRef,
  usersAlgorithmDataRef,
  usersPrivateInfoRef,
} from '../constants';

export default functions.firestore
  .document(
    'thisdocdoesnotexist/{andwillneverbecreated}/butthisfunctionwillbecalledmanually/thequickbrownfoxjumpsoverthelazydog'
  )
  .onCreate(async (_snapshot, _context) => {
    const users: Array<FirebaseFirestore.DocumentData> = [];
    for (const algorithmData of (
      await usersAlgorithmDataRef.where('asleep', '==', false).get()
    ).docs) {
      const profile = (
        await userProfilesRef.doc(algorithmData.id).get()
      ).data();
      if (profile == null) {
        throw 'Could not get user profile: ' + algorithmData.id;
      }
      users.push({
        uid: algorithmData.id,
        gender: profile.gender,
        birthday: profile.birthday.toDate(),
        personalInfo: profile.personalInfo,
        interests: profile.interests,
        ...algorithmData.data(),
      });
    }

    const uidToSuggestions = generateSuggestions(users);
    for (const uid in uidToSuggestions) {
      usersPrivateInfoRef.doc(uid).update({
        dailyGeneratedSuggestions: uidToSuggestions.get(uid),
      });
    }
  });
