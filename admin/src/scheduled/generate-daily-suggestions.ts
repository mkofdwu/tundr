import {
  userProfilesRef,
  usersAlgorithmDataRef,
  usersPrivateInfoRef,
} from '../constants';
import makeMatches from '../algorithms/matchmaker';

export default async () => {
  const users: Array<FirebaseFirestore.DocumentData> = [];
  for (const algorithmData of (
    await usersAlgorithmDataRef.where('asleep', '==', false).get()
  ).docs) {
    const profile = (await userProfilesRef.doc(algorithmData.id).get()).data();
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
  console.log('Users:');
  console.log(users);

  const uidToSuggestions = makeMatches(users);

  console.log('Generated suggestions:');
  console.log(uidToSuggestions);
  for (const [uid, suggestions] of uidToSuggestions) {
    await usersPrivateInfoRef.doc(uid).update({
      dailyGeneratedSuggestions: suggestions,
    });
  }
};
