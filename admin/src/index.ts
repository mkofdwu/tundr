import generateDailySuggestions from './scheduled/generate-daily-suggestions';

(async () => {
  await generateDailySuggestions();
  console.log('done');
})();
