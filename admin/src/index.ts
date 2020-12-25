import { migrateChatTyping } from './migrations';

migrateChatTyping().then(() => console.log('DONE'));
