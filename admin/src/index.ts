import { deleteAccount } from './management/delete-account';
// import { addHomeworkList } from './migrations';

(async () => {
  await deleteAccount('johncremley');
  console.log('done');
})();
