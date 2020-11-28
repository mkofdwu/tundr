// import * as functions from 'firebase-functions';
// import * as admin from 'firebase-admin';
// import { randomBytes } from 'crypto';

// import { db } from '../../functions/src/constants';

// export default functions.firestore
//   .document('haoenutaoheusahoesuhoaeu/haoseunoaeua/aoeuatohuao/aoethutnsahous')
//   .onCreate(async (snapshot, context) => {
//     /*
//      * provide these fields in snapshot.data:
//      * - num (number of users)
//      * - birthdayYearMin
//      * - birthdayYearMax
//      * - gender
//      */

//     // let data: FirebaseFirestore.DocumentData | undefined = snapshot.data();
//     // if (data == undefined) {
//     //   console.log(
//     //     "No data. Provide the number of test accounts to generate and range of the year of birth"
//     //   );
//     //   return;
//     // }
//     let data = {
//       num: 50,
//       birthdayYearMin: 2004,
//       birthdayYearMax: 2006,
//       gender: 0,
//     };
//     let num: number = data.num;
//     let birthdayYearMin: number = data.birthdayYearMin;
//     let birthdayYearMax: number = data.birthdayYearMax;

//     for (let _: number = 0; _ < num; ++_) {
//       let username: string = randomBytes(10).toString('hex');

//       let userProperties: admin.auth.CreateRequest = {
//         email: `${username}@example.com`,
//         password: '123456',
//       };
//       let user: admin.auth.UserRecord = await admin
//         .auth()
//         .createUser(userProperties);

//       let gender: number = data.gender ?? Math.floor(Math.random() * 2); // 2 possible genders
//       let birthdayYear: number =
//         birthdayYearMin +
//         Math.floor(Math.random() * (birthdayYearMax - birthdayYearMin));
//       let birthdayMonth: number = 1 + Math.floor(Math.random() * 12);
//       let birthday: Date = new Date(birthdayYear, birthdayMonth, 1);

//       db.collection('users')
//         .doc(user.uid)
//         .set({
//           phoneNumber: '',
//           username: username,
//           name:
//             `Fake ${gender == 0 ? 'Man' : 'Woman'} ` +
//             `${username.substring(0, 5)}`,
//           gender: gender,
//           profileImageUrl: '', // TODO:
//           aboutMe: '',
//           birthday: admin.firestore.Timestamp.fromDate(birthday),
//           interests: [],
//           extraMedia: Array(9).fill(null),
//           verified: Math.floor(Math.random() * 2) == 1,
//           asleep: false,
//           online: false,
//           lastSeen: admin.firestore.Timestamp.fromMillis(Date.now()),
//           popularityScore: 100,
//           conversationalScore: 0,
//           blockedScore: 0,
//           showMeBoys: gender == 1,
//           showMeGirls: gender == 0,
//           ageRangeMin: 2020 - birthdayYear - 1, // FIXME:
//           ageRangeMax: 2020 - birthdayYear + 1,
//           newMatchNotification: false,
//           messageNotification: false,
//           blockUnknownMessages: false,
//           readReceipts: Math.floor(Math.random() * 2) == 1,
//           showInMostPopular: true,
//           popularityHistory: {},
//           totalWordsSent: 0,
//           theme: 0,
//           numRightSwiped: 0,
//         });
//     }
//   });
