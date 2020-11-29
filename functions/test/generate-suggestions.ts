import generateSuggestions from '../src/algorithms/generate-suggestions';
import allUsers from './fixtures/user-algorithm-details';

const res = generateSuggestions(allUsers);
console.log(res);
