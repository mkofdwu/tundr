// import { migrateChatTyping } from './migrations';

import { removeIncompleteUsers } from './migrations';

// migrateChatTyping().then(() => console.log('DONE'));

removeIncompleteUsers().then(() => console.log('DONE'));
