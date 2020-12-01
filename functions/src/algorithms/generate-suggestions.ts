import { interestsToGroupNo, numInterestGroups } from '../constants';
import { FilterMethod } from '../enums/filter-method';
import Filter from '../models/filter';
import pearsonCorrelation from '../utils/pearson-correlation';
import transposeArray from '../utils/transpose-array';

const N = 10; // maximum amount of suggestions generated per day for each user

const valuePassesFilter = (value: any, filter: Filter) => {
  switch (filter.name) {
    case 'Height':
    case 'Personality':
    case 'K-Pop':
    case 'Anime':
      return filter.options[0] <= value && value <= filter.options[1];
    case 'Religion':
    case 'Star sign':
    case 'Relationship status':
      return filter.options.includes(value);
    case 'Pets':
      switch (filter.method) {
        case FilterMethod.none:
          return true;
        case FilterMethod.ifContainsAll:
          return value.every((item: any) => filter.options.includes(item));
        case FilterMethod.ifContainsAny:
          return value.some((item: any) => filter.options.includes(item));
        default:
          throw new Error('invalid filter method: ' + filter.method);
      }
    default:
      throw new Error('invalid filter field name: ' + filter.name);
  }
};

const otherUserPassesFilters = (
  user: FirebaseFirestore.DocumentData,
  otherUser: FirebaseFirestore.DocumentData
) => {
  // NOTE: gender is already verified to be acceptable
  // TODO: FIXME: may encounter problems keeping filters & personal info consistent between client & functions
  if (
    (Date.now() - otherUser.birthday) / 31536000000 < user.ageRangeMin ||
    (Date.now() - otherUser.birthday) / 31536000000 > user.ageRangeMax
  )
    return false;
  for (const filterFieldName in user.filters) {
    const { options, method } = user.filters[filterFieldName];
    const value = otherUser.personalInfo[filterFieldName];
    if (!valuePassesFilter(value, { name: filterFieldName, method, options }))
      return false;
  }
  return true;
};

export default (allUsers: Iterable<FirebaseFirestore.DocumentData>) => {
  // load all users into memory

  const males: Array<FirebaseFirestore.DocumentData> = []; // males who want to be shown females
  const females: Array<FirebaseFirestore.DocumentData> = []; // females who want to be shown males
  const gays: Array<FirebaseFirestore.DocumentData> = []; // males who want to be shown males
  const lesbians: Array<FirebaseFirestore.DocumentData> = []; // females who want to be shown females

  for (const user of allUsers) {
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
  }

  // compute the interest vectors for all users

  const usersInterestsVectors: Map<
    string, // user id
    Array<number>
  > = new Map(); // map of documentsnapshot to interestVector

  for (const user of allUsers) {
    const interestsVector: Array<number> = new Array(numInterestGroups).fill(0);
    user.interests.forEach((interest: string) => {
      const groupNo = interestsToGroupNo[interest];
      ++interestsVector[groupNo];
    });
    usersInterestsVectors.set(user.uid, interestsVector);
  }

  // calculate all the users similarities to each other

  const maleToFemaleSimilaritiesMatrix: Array<Array<number>> = new Array(
    males.length
  ).fill([]);

  const calculateSimilaritiesWithinSameSex = (
    sexualityMembers: Array<FirebaseFirestore.DocumentData>
  ) => {
    const similaritiesMatrix: Array<Array<number>> = new Array(
      sexualityMembers.length
    ).fill([]);
    for (let i = 0; i < sexualityMembers.length; ++i) {
      const user = sexualityMembers[i];
      const interestsVector = usersInterestsVectors.get(user.uid);
      if (interestsVector == null)
        throw new Error('could not get interests vector for user: ' + user.uid);

      for (let j = i + 1; j < sexualityMembers.length; ++j) {
        // calculate similarity with all males after him (triangle number)
        const otherUser = sexualityMembers[j];
        const otherInterestsVector = usersInterestsVectors.get(otherUser.uid);
        if (otherInterestsVector == null)
          throw new Error('could not get interests for user: ' + otherUser.uid);

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
      throw new Error('could not get interests vector for user: ' + male);

    for (let femaleIndex = 0; femaleIndex < females.length; ++femaleIndex) {
      const female = females[femaleIndex];
      const otherInterestsVector = usersInterestsVectors.get(female.uid);
      if (otherInterestsVector == null)
        throw new Error('could not get interests for user: ' + female.uid);

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

  const addTopNSuggestions = (
    sexualityMembers: Array<FirebaseFirestore.DocumentData>,
    targetSexualityMembers: Array<FirebaseFirestore.DocumentData>,
    similarityMatrix: Array<Array<number>>
  ) => {
    for (let i = 0; i < sexualityMembers.length; ++i) {
      const user = sexualityMembers[i];
      const usersAndScoresSorted = similarityMatrix[i]
        .map((score, j) => [targetSexualityMembers[j], score]) // label each score with the user object
        .sort(
          (userAndScore1, userAndScore2) =>
            <number>userAndScore2[1] - <number>userAndScore1[1]
        ); // sort by score in descending order
      const thisSuggestions = [];
      for (const userAndScore of usersAndScoresSorted) {
        const otherUser = <FirebaseFirestore.DocumentData>userAndScore[0];
        if (otherUserPassesFilters(user, otherUser)) {
          thisSuggestions.push(otherUser.uid);
          if (thisSuggestions.length >= N) break;
        }
      }

      const userSuggestions = generatedSuggestions.get(user.uid);
      if (userSuggestions != null) {
        userSuggestions.push(...thisSuggestions);
      } else {
        generatedSuggestions.set(user.uid, thisSuggestions);
      }
    }
  };

  addTopNSuggestions(males, females, maleToFemaleSimilaritiesMatrix);
  addTopNSuggestions(
    females,
    males,
    transposeArray(maleToFemaleSimilaritiesMatrix)
  );
  addTopNSuggestions(gays, gays, gaysSimilaritiesMatrix);
  addTopNSuggestions(lesbians, lesbians, lesbiansSimilaritiesMatrix);

  return generatedSuggestions;
};
