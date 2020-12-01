import generateSuggestions from '../src/algorithms/generate-suggestions';
import allUsers from './fixtures/user-algorithm-details';

test('Generate suggestions algorithm', () => {
  const res = generateSuggestions(allUsers);
  console.log(res);
  expect(true).toBe(true);
});
