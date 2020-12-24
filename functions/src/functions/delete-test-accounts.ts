import * as functions from 'firebase-functions';
import { userProfilesRef } from '../constants';

export default functions.firestore
  .document('haoenutaoheusahoesuhoaeu/haoseunoaeua/aoeuatohuao/aoethutnsahous')
  .onCreate(async (_snapshot, _context) => {
    const profileDocs = (await userProfilesRef.get()).docs;
    for (const profileDoc of profileDocs) {
      const name: string = profileDoc.data()['name'];
      if (name.endsWith(' (test)')) {
        await profileDoc.ref.delete();
      }
    }
  });
