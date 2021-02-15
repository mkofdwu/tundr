import updatePopularityScores from './scheduled/update-popularity-scores';

(async () => {
  await updatePopularityScores();
  console.log('done');
})();
