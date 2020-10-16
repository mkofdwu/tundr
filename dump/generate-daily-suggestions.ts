// (await db.collection("users").get()).forEach(async (userDoc) => {
//   const generatedDailySuggestions = new Array<String>();
//   const user = userDoc.data();
//   const filteredUsers = await getFilteredUsers(user);

//   filteredUsers.forEach((otherUser) => {
//     const interestsSimilarity = jaccardSimilarity(
//       user.interests,
//       otherUser.interests
//     );
//     const
//   });

//   userDoc.ref.update({ numRightSwiped: 0, generatedDailySuggestions });
// });

// attempt 2

// const usersByGender: Array<Array<FirebaseFirestore.DocumentData>> = [
//   [],
//   [],
// ]; // male, female
// (await db.collection("users").get()).forEach((userDoc) => {
//   const user = userDoc.data();
//   usersByGender[user.gender].push(userDoc);
// });

// // using user-user filtering for likes

// // 1: construct vectors for each male
// const rateVectorList = []; // each element corresponds to the rateVector of each male in usersByGender[0]
// for (const userDoc of usersByGender[0]) {
//   const user: FirebaseFirestore.DocumentData = userDoc.data();
//   const rateVector: Array<number> = [];
//   for (let i = 0; i < usersByGender[1].length; ++i) {
//     if (user.liked.includes(usersByGender[1][i])) {
//       rateVector.push(1);
//     } else if (user.disliked.includes(usersByGender[1][i])) {
//       rateVector.push(0);
//     } else {
//       rateVector.push(null);
//     }
//     rateVectorList.push(rateVector);
//   }
// }

// // 2: calculate similarity between males
// const similarityMatrix: Array<Array<number>> = [];
// for (let i = 0; i < usersByGender[0].length; ++i) {
//   for (let j = i + 1; j < usersByGender[0].length; ++j) {
//     const similarity = pearsonCorrelation(
//       rateVectorList[i],
//       rateVectorList[j]
//     );
//     similarityMatrix[i][j] = similarity;
//     similarityMatrix[j][i] = similarity; // for convenience;
//   }
// }

// // 3: for each male, top N most similar are used to predict

// const N = 5;
// for (let i = 0; i < usersByGender[0].length; ++i) {
//   const topN: Array<number> = [];
//   const topSimilarities: Array<number> = []; // in descending order
//   for (
//     let userIndex = 0;
//     userIndex < similarityMatrix[i].length;
//     ++userIndex
//   ) {
//     while (similarityMatrix[i][userIndex] > topN) userIndex;
//   }
// }
