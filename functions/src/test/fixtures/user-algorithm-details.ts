export const numUsers = 10;
export const userAlgorithmDetails: Array<FirebaseFirestore.DocumentData> = [];

for (let i = 0; i < numUsers; ++i) {
  userAlgorithmDetails.push({
    uid: i.toString(),
    gender: Math.random() > 0.5 ? 0 : 1,
    showMeBoys: Math.random() > 0.5,
    showMeGirls: Math.random() > 0.5,
    // TODO
    ageRangeMin: ,
    ageRangeMax: ,
    filters: {},
    personalInfo: {},
    interests: [],
  })
}
