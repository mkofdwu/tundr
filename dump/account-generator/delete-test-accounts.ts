// import * as functions from 'firebase-functions';

// import { db } from '../../constants';

// export default functions.firestore
//   .document('htnsaeunahtoe/nsaeu/nashteu/ahseunseu')
//   .onCreate(async (context, snapshot) => {
//     (
//       await db
//         .collection('users')
//         .where('name', '>=', 'Fake')
//         .where('name', '<=', 'Fakf')
//         .get()
//     ).forEach((doc) => {
//       const docData = doc.data();
//       console.log(`name: ${docData['name']}`);
//       if (docData['name'].startsWith('Fake')) doc.ref.delete();
//     });
//   });
