import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import {
  interestsList,
  userProfilesRef,
  usersAlgorithmDataRef,
  usersPrivateInfoRef,
  userStatusesRef,
} from '../constants';
import fetch from 'node-fetch';

const maleFirstNames = [
  'Soham',
  'Philip',
  'Francisco',
  'Darrell',
  'Randall',
  'Bernard',
  'Shane',
  'Cody',
  'Floyd',
  'Gregory',
  'Cameron',
  'Eduardo',
  'Dwight',
  'Jacob',
  'Mitchell',
  'Wade',
  'Pat',
  'Guy',
  'Harold',
  'Marvin',
  'Nathan',
  'Bruce',
  'Calvin',
  'Lee',
  'Robert',
  'Jorge',
  'Ronald',
  'Dustin',
  'Leslie',
  'Brandon',
];

const femaleFirstNames = [
  'Claire',
  'Irma',
  'Judith',
  'Bessie',
  'Brandie',
  'Darlene',
  'Audrey',
  'Priscilla',
  'Gloria',
  'Courtney',
  'Bessie',
  'Julie',
  'Serenity',
  'Regina',
  'Connie',
  'Kathryn',
  'Theresa',
  'Aubrey',
  'Bessie',
  'Colleen',
  'Savannah',
  'Jane',
  'Tanya',
  'Kristin',
  'Gladys',
  'Lily',
  'Wendy',
  'Arlene',
  'Esther',
  'Dianne',
];

const lastNames = ['Lane', 'Richards', 'Fox', 'Warren', 'Edwards', 'Hawkins'];

const choice = (arr: Array<any>) => arr[Math.floor(Math.random() * arr.length)];

function randomName(isMale: boolean) {
  return (
    choice(isMale ? maleFirstNames : femaleFirstNames) + ' ' + choice(lastNames)
  );
}

function getRandomSubarray(arr: Array<any>, size: number) {
  var shuffled = arr.slice(0),
    i = arr.length,
    temp,
    index;
  while (i--) {
    index = Math.floor((i + 1) * Math.random());
    temp = shuffled[index];
    shuffled[index] = shuffled[i];
    shuffled[i] = temp;
  }
  return shuffled.slice(0, size);
}

function randRange(min: number, max: number) {
  return Math.random() * (max - min) + min;
}

export const generateTestAccounts = functions.firestore
  .document('haoenutaoheusahoesuhoaeu/haoseunoaeua/aoeuatohuao/aoethutnsahous')
  .onCreate(async (_snapshot, _context) => {
    const num: number = 50;
    const birthdayYearMin: number = 2004;
    const birthdayYearMax: number = 2006;

    for (let _: number = 0; _ < num; ++_) {
      const gender = Math.floor(Math.random() * 2); // 2 possible genders
      const name: string = randomName(gender == 0);
      const username = name.replace(' ', '').toLowerCase() + '_test';

      const userProperties: admin.auth.CreateRequest = {
        email: `${username}@example.com`,
        password: '123456',
      };
      const user: admin.auth.UserRecord = await admin
        .auth()
        .createUser(userProperties);
      const birthdayYear: number =
        birthdayYearMin +
        Math.floor(Math.random() * (birthdayYearMax - birthdayYearMin));
      const birthdayMonth: number = 1 + Math.floor(Math.random() * 12);
      const birthday: Date = new Date(birthdayYear, birthdayMonth, 1);

      const res = await fetch('https://picsum.photos/700/900');
      console.log(res.url);

      await userProfilesRef.doc(user.uid).set({
        uid: user.uid,
        username,
        name: name + ' (test)',
        gender,
        birthday: admin.firestore.Timestamp.fromDate(birthday),
        aboutMe: 'This isnt a real account. Just for testing',
        profileImageUrl: res.url,
        extraMedia: Array(9).fill(null),
        personalInfo: {}, // NOTE: this is empty because personal info does not affect the algorithm as of now
        interests: getRandomSubarray(interestsList, randRange(10, 40)),
        customInterests: [],
        verified: Math.floor(Math.random() * 2) == 1, // randomly verified
      });

      await usersPrivateInfoRef.doc(user.uid).set({
        phoneNumber: '',
        popularityHistory: [`${Date.now()}:100`],
        popularityScore: 100,
        settings: {
          newMatchNotification: false,
          messageNotification: false,
          blockUnknownMessages: false,
          readReceipts: true,
          showInMostPopular: true,
        },
        dailyGeneratedSuggestions: [],
        respondedSuggestions: {},
        theme: null,
        numRightSwiped: 0,
        blocked: [],
      });

      // NOTE: everyone is at least straight so there are no completely gay
      // people generated, just bi, so as to cater to everyone
      const isGay = Math.random() < 0.1;

      const age = (Date.now() - birthday.getMilliseconds()) / 31536000000;

      await usersAlgorithmDataRef.doc(user.uid).set({
        asleep: false,
        showMeBoys: isGay ? true : gender === 1,
        showMeGirls: isGay ? true : gender === 0,
        ageRangeMin: age - 1,
        ageRangeMax: age + 1,
        otherFilters: {},
        suggestionsGoneThrough: {},
      });

      await userStatusesRef.doc(user.uid).set({
        online: false,
        lastSeen: admin.firestore.Timestamp.fromMillis(Date.now()),
      });
    }
  });

export const deleteTestAccounts = functions.firestore
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
