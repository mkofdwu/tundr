import { userProfilesRef } from '../constants';

export const usernameFromName = async (username: string) => {
  const profileDoc = (await userProfilesRef.where('name', '>=', username).get())
    .docs[0];
  console.log(profileDoc.data()['username']);
};
