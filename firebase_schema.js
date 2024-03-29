// NOTE: type `Object` refers to any arbitary type

class Integer extends Number {}
class Double extends Number {}

class Timestamp {}

const user_profiles = Collection({
  userId: {
    uid: 'userId',
    username: String,
    name: String,
    gender: Integer,
    birthday: Timestamp,
    aboutMe: String,
    profileImageUrl: String,
    extraMedia: [String], // array of length 9
    personalInfo: { String: Object },
    interests: [String],
    customInterests: [String],
    verified: Boolean,
  },
});

const users_private_info = Collection({
  userId: {
    phoneNumber: String,
    popularityHistory: { Integer: Double },
    popularityScore: Double,
    settings: {
      newMatchNotification: Boolean,
      messageNotification: Boolean,
      blockUnknownMessages: Boolean,
      readReceipts: Boolean,
      showInMostPopular: Boolean,
    },
    dailyGeneratedSuggestions: ['userId'],
    respondedSuggestions: { String: Boolean },
    theme: Integer,
    numRightSwiped: Integer,
    blocked: ['userId'],
    chats: Collection({
      // contains both unknown and normal (and other types of) chats
      chatId: {
        uid: 'userId', // other user
        wallpaperUrl: String, // url
        lastReadMessageId: 'messageId',
        type: Integer,
      },
    }),
  },
});

const users_algorithm_data = Collection({
  asleep: Boolean,
  showMeBoys: Boolean,
  showMeGirls: Boolean,
  ageRangeMin: Integer,
  ageRangeMax: Integer,
  otherFilters: {
    personalInfoField: { method: Integer, options: Object },
  },
  suggestionsGoneThrough: { String: Boolean },
});

const user_statuses = Collection({
  userId: {
    online: bool,
    lastSeen: Timestamp,
  },
});

const chats = Collection({
  chatId: {
    participants: ['userId'],
    typing: ['userId'],
    messages: [
      {
        senderUid: 'userId',
        readOn: Timestamp,
        sentOn: Timestamp,
        referencedMessageId: 'messageId',
        text: String,
        mediaType: Integer,
        mediaUrl: String,
      },
    ],
  },
});
