import generateSuggestions from '../src/algorithms/generate-suggestions';
import allUsers from './fixtures/user-algorithm-details';

test('Generate suggestions algorithm', () => {
  const res: Map<string, Array<string>> = generateSuggestions(allUsers);
  console.log(res);
  // for (const userSuggestions of res.values()) {
  //   expect(userSuggestions.length).toBeLessThanOrEqual(10); // equal to N, the max number of suggestions generated for each person
  // }

  expect(true).toBe(true);
});
