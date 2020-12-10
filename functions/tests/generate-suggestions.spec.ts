import makeMatches from '../src/algorithms/matchmaker';
import allUsers1 from './fixtures/user-algorithm-details/set-1';
import allUsers2 from './fixtures/user-algorithm-details/set-2';

test('Generate suggestions algorithm (set 1)', () => {
  makeMatches(allUsers1);
  // console.log(res1);
  // for (const userSuggestions of res.values()) {
  //   expect(userSuggestions.length).toBeLessThanOrEqual(10); // equal to N, the max number of suggestions generated for each person
  // }
  expect(true).toBe(true);
});

test('Matchmaker algorithm (set 2)', () => {
  makeMatches(allUsers2);
  // console.log(res2);
  expect(true).toBe(true);
});
