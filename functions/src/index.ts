import onMatch from "./functions/events/on-match";
import onMessage from "./functions/events/on-message";
import generateDailySuggestions from "./functions/generate-daily-suggestions";
import updatePopularityScore from "./functions/scheduled/update-popularity-score";
import createAccount from "./account-generator/create-account";
import generateTestAccounts from "./account-generator/generate-test-accounts";
import deleteTestAccounts from "./account-generator/delete-test-accounts";

export {
  onMatch,
  onMessage,
  generateDailySuggestions,
  updatePopularityScore,
  createAccount,
  generateTestAccounts,
  deleteTestAccounts,
};

export const _generateDailySuggestions = functions.firestore
  .document(
    "thisdocdoesnotexist/{andwillneverbecreated}/butthisfunctionwillbecalledmanually/thequickbrownfoxjumpsoverthelazydog"
  )
  .onCreate(async (snapshot, context) => {
    generateDailySuggestions(snapshot, context);
  });
