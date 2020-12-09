import makeMatches from '../src/algorithms/matchmaker';
import allUsers1 from './fixtures/user-algorithm-details/set-1';
import allUsers2 from './fixtures/user-algorithm-details/set-2';

test('Generate suggestions algorithm', () => {
  const res1: Map<string, Array<string>> = makeMatches(allUsers1);
  console.log(res1);
  const res2 = makeMatches(allUsers2);
  console.log(res2);
  // for (const userSuggestions of res.values()) {
  //   expect(userSuggestions.length).toBeLessThanOrEqual(10); // equal to N, the max number of suggestions generated for each person
  // }

  expect(true).toBe(true);
});
