import admin = require('firebase-admin');
import {
  userProfilesRef,
  usersAlgorithmDataRef,
  usersPrivateInfoRef,
  userStatusesRef,
} from '../constants';

export const deleteAccount = async (username: string) => {
  const profileDoc = (
    await userProfilesRef.where('username', '==', username).get()
  ).docs[0];
  await admin.auth().deleteUser(profileDoc.id);
  await profileDoc.ref.delete();
  await usersPrivateInfoRef.doc(profileDoc.id).delete();
  await usersAlgorithmDataRef.doc(profileDoc.id).delete();
  await userStatusesRef.doc(profileDoc.id).delete();
};
