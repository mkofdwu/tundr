import { deleteAccount } from './management/delete-account';
import { usernameFromName } from './management/username-from-name';
import generateDailySuggestions from './scheduled/generate-daily-suggestions';
import updatePopularityScores from './scheduled/update-popularity-scores';

(async () => {
  await generateDailySuggestions();
  await updatePopularityScores();
  console.log('done');
})();
