import { addHomeworkList } from './migrations';

(async () => {
  await addHomeworkList();
  console.log('done');
})();
