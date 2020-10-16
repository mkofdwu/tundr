import { interestsToGroupNo, numInterestGroups } from "../constants";
import pearsonCorrelation from "../algorithms/pearson-correlation";
import { firestore } from "firebase-admin";

const N = 5;

const otherUserPassesFilters = (
  user: FirebaseFirestore.DocumentData,
  otherUser: FirebaseFirestore.DocumentData
) => {
  if (
    (Date.now() - otherUser.birthday) / 31536000000 < user.ageRangeMin ||
    (Date.now() - otherUser.birthday) / 31536000000 > user.ageRangeMax
  )
    return false;
  return true;
};

export default async (allUsers: Array<FirebaseFirestore.DocumentData>) => {
  // load all users into memory

  const males: Array<FirebaseFirestore.DocumentData> = []; // males who want to be shown females
  const females: Array<FirebaseFirestore.DocumentData> = []; // females who want to be shown males
  const gays: Array<FirebaseFirestore.DocumentData> = []; // males who want to be shown males
  const lesbians: Array<FirebaseFirestore.DocumentData> = []; // females who want to be shown females

  allUsers.forEach((user) => {
    if (user.gender === 0) {
      if (user.showMeGirls) {
        males.push(user);
      }
      if (user.showMeBoys) {
        gays.push(user);
      }
    } else if (user.gender === 1) {
      if (user.showMeBoys) {
        females.push(user);
      }
      if (user.showMeGirls) {
        lesbians.push(user);
      }
    }
  });

  // compute the interest vectors for all users

  const usersInterestsVectors: Map<
    string, // user id
    Array<number>
  > = new Map(); // map of documentsnapshot to interestVector

  allUsers.forEach((user) => {
    const interestsVector: Array<number> = new Array(numInterestGroups);
    user.interests.forEach((interest: string) => {
      const groupNo = interestsToGroupNo[interest];
      ++interestsVector[groupNo];
    });
    usersInterestsVectors.set(user.uid, interestsVector);
  });

  // calculate all the users similarities to each other

  const maleToFemaleSimilaritiesMatrix: Array<Array<number>> = [];

  const calculateSimilaritiesWithinSameSex = (
    sexualityMembers: Array<FirebaseFirestore.DocumentData>
  ) => {
    const similaritiesMatrix: Array<Array<number>> = [];
    for (let i = 0; i < sexualityMembers.length; ++i) {
      const user = sexualityMembers[i];
      const interestsVector = usersInterestsVectors.get(user.uid);
      if (interestsVector == null)
        throw new Error("could not get interests vector for user: " + user.uid);

      for (let j = i + 1; j < sexualityMembers.length; ++j) {
        // calculate similarity with all males after him (triangle number)
        const otherUser = sexualityMembers[j];
        const otherInterestsVector = usersInterestsVectors.get(otherUser.uid);
        if (otherInterestsVector == null)
          throw new Error("could not get interests for user: " + otherUser.uid);

        const similarityScore = pearsonCorrelation(
          interestsVector,
          otherInterestsVector
        );

        similaritiesMatrix[i][j] = similarityScore;
      }
    }
    return similaritiesMatrix;
  };

  for (let maleIndex = 0; maleIndex < males.length; ++maleIndex) {
    const male = males[maleIndex];
    const interestsVector = usersInterestsVectors.get(male.uid);
    if (interestsVector == null)
      throw new Error("could not get interests vector for user: " + male);

    for (let femaleIndex = 0; femaleIndex < females.length; ++femaleIndex) {
      const female = females[femaleIndex];
      const otherInterestsVector = usersInterestsVectors.get(female.uid);
      if (otherInterestsVector == null)
        throw new Error("could not get interests for user: " + female.uid);

      const similarityScore = pearsonCorrelation(
        interestsVector,
        otherInterestsVector
      );
      maleToFemaleSimilaritiesMatrix[maleIndex][femaleIndex] = similarityScore;
    }
  }

  const gaysSimilaritiesMatrix = calculateSimilaritiesWithinSameSex(gays);
  const lesbiansSimilaritiesMatrix = calculateSimilaritiesWithinSameSex(
    lesbians
  );

  const generatedSuggestions: Map<string, Array<string>> = new Map();

  for (let maleIndex = 0; maleIndex < males.length; ++maleIndex) {
    const male = males[maleIndex];
    const femalesAndScoresSorted = maleToFemaleSimilaritiesMatrix[maleIndex]
      .map((score, femaleIndex) => [females[femaleIndex], score]) // label each score with the user object
      .sort(
        (userAndScore1, userAndScore2) =>
          <number>userAndScore2[1] - <number>userAndScore1[1]
      ); // sort by score in descending order
    const thisSuggestions = [];
    for (const userAndScore of femalesAndScoresSorted) {
      const female = <FirebaseFirestore.DocumentData>userAndScore[0];
      if (otherUserPassesFilters(male, female)) {
        thisSuggestions.push(female.uid);
      }
    }
    generatedSuggestions.set(male.uid, thisSuggestions);
  }

  for (let femaleIndex = 0; femaleIndex < females.length; ++femaleIndex) {
    const female = females[femaleIndex];
    const malesAndScoresSorted = maleToFemaleSimilaritiesMatrix
      .map((arr) => arr[femaleIndex]) // get column of male similarities
      .map((score, maleIndex) => [males[maleIndex], score]) // label each score with the user object
      .sort(
        (userAndScore1, userAndScore2) =>
          <number>userAndScore2[1] - <number>userAndScore1[1]
      ); // sort by score in descending order
    const thisSuggestions = [];
    for (const userAndScore of malesAndScoresSorted) {
      const male = <FirebaseFirestore.DocumentData>userAndScore[0];
      if (otherUserPassesFilters(female, male)) {
        thisSuggestions.push(male.uid);
      }
    }
    generatedSuggestions.set(female.uid, thisSuggestions);
  }

  for (let gayIndex = 0; gayIndex < gays.length; ++gayIndex) {
    const gay = gays[gayIndex];
    const thisSuggestions = [];
  }
};
