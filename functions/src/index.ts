import onMessage from './functions/on-message';
import generateDailySuggestions from './functions/generate-daily-suggestions';
import updatePopularityScore from './functions/update-popularity-score';

export { onMessage, generateDailySuggestions, updatePopularityScore };

export * from './functions/users-http';
export * from './functions/chats-http';
export * from './functions/suggestions-http';
