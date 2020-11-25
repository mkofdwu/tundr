import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { randomBytes } from 'crypto';

import { db } from '../../constants';

export default functions.firestore
  .document('/newusers/{uid}')
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
      console.log('no data in document');
      return;
    }
    console.log(data.birthday);
    console.log(data.birthday.toDate());
    db.collection('users')
      .doc(uid)
      .set({
        phoneNumber: '',
        username: data.username ?? randomBytes(10).toString('hex'),
        name: data.name ?? 'Unknown',
        gender: data.gender,
        profileImageUrl: '',
        aboutMe: '',
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
        numRightSwiped: 0,
      });
    db.collection('usersuggestionsgonethrough')
      .doc(uid)
      .set({ suggestionsGoneThrough: [] });
  });
