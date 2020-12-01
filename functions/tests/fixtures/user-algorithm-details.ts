export default [
  {
    uid: '0',
    gender: 0,
    birthday: new Date(2003, 12, 1),
    showMeBoys: false,
    showMeGirls: true,
    ageRangeMin: 18,
    ageRangeMax: 19,
    otherFilters: {
      Personality: { options: [2, 4] },
      Pets: { options: ['Hamster', 'Serpent'], method: 1 },
      'Relationship status': { options: ['Single', 'Taken'] },
      Anime: { options: [1, 4] },
    },
    personalInfo: {
      Height: 167,
      Personality: 4,
      Pets: ['Fish', 'Cat'],
      'Relationship status': 'Taken',
      'Star sign': 'Sagittarius',
      Religion: 'Christianity',
      'K-Pop': 5,
      Anime: 4,
    },
    interests: [
      'Relationships',
      'Robotics',
      'Fine Arts',
      'Acting',
      'Meteorology',
      'Classical Music',
      'Israel',
      'Soundtracks',
      'Spirituality',
      'Electronic Parts',
    ],
  },
  {
    uid: '1',
    gender: 1,
    birthday: new Date(2002, 12, 1),
    showMeBoys: true,
    showMeGirls: true,
    ageRangeMin: 15,
    ageRangeMax: 19,
    otherFilters: {
      Height: { options: [168, 207] },
      Personality: { options: [3, 4] },
      'K-Pop': { options: [2, 4] },
      Anime: { options: [2, 5] },
    },
    personalInfo: {
      Height: 152,
      Personality: 1,
      Pets: [],
      'Relationship status': 'Single',
      'Star sign': 'Leo',
      Religion: 'Christianity',
      'K-Pop': 1,
      Anime: 3,
    },
    interests: [
      'Climbing',
      'Spain',
      'Mental Health',
      'Cyberculture',
      'Quilting',
      'Dance Music',
    ],
  },
  {
    uid: '2',
    gender: 1,
    birthday: new Date(2005, 12, 1),
    showMeBoys: true,
    showMeGirls: false,
    ageRangeMin: 14,
    ageRangeMax: 16,
    otherFilters: {
      Personality: { options: [2, 5] },
      Pets: { options: ['Fish', 'Dog', 'Tarantula'], method: 1 },
      'Relationship status': { options: ['Single'] },
      'Star sign': { options: ['Gemini', 'Leo', 'Capricorn', 'Cancer'] },
      'K-Pop': { options: [2, 5] },
    },
    personalInfo: {
      Height: 188,
      Personality: 5,
      Pets: ['Hamster', 'Tarantula'],
      'Relationship status': 'Single',
      'Star sign': 'Pisces',
      Religion: 'Buddhism',
      'K-Pop': 3,
      Anime: 4,
    },
    interests: [
      'Relationships',
      'Beer',
      'Musicals',
      'Drugs',
      'Machinery',
      'Outdoors',
      'Computer Graphics',
      'Biotech',
      'Romance Novels',
      'Marketing',
      'Spirituality',
      'Capitalism',
    ],
  },
  {
    uid: '3',
    gender: 1,
    birthday: new Date(2004, 12, 1),
    showMeBoys: true,
    showMeGirls: true,
    ageRangeMin: 16,
    ageRangeMax: 19,
    otherFilters: {},
    personalInfo: {
      Height: 180,
      Personality: 5,
      Pets: [],
      'Relationship status': 'Taken',
      'Star sign': 'Virgo',
      Religion: 'Hinduism',
      'K-Pop': 4,
      Anime: 3,
    },
    interests: [
      'Career planning',
      'Christian Music',
      'Disabilities',
      'Classic Films',
      'Fitness',
      'Arts',
    ],
  },
  {
    uid: '4',
    gender: 0,
    birthday: new Date(2005, 12, 1),
    showMeBoys: false,
    showMeGirls: true,
    ageRangeMin: 12,
    ageRangeMax: 17,
    otherFilters: {},
    personalInfo: {
      Height: 179,
      Personality: 1,
      Pets: ['Cat'],
      'Relationship status': 'Single',
      'Star sign': 'Taurus',
      Religion: 'Buddhism',
      'K-Pop': 3,
      Anime: 4,
    },
    interests: [
      'Radio Broadcasts',
      'Architecture',
      'MacOS',
      'Design',
      'Skiing',
      'Beverages',
      'Manufacturing',
      'Cold War',
      'Netherlands',
      'Marketing',
      'Audio Equipment',
      'Programming',
      'Tattoos/Piercing',
    ],
  },
  {
    uid: '5',
    gender: 0,
    birthday: new Date(2003, 12, 1),
    showMeBoys: false,
    showMeGirls: false,
    ageRangeMin: 17,
    ageRangeMax: 19,
    otherFilters: {},
    personalInfo: {
      Height: 162,
      Personality: 4,
      Pets: ['Donkey', 'Hamster', 'Serpent'],
      'Relationship status': 'Single',
      'Star sign': 'Aries',
      Religion: 'Islam',
      'K-Pop': 3,
      Anime: 1,
    },
    interests: ['Sex', 'PHP', 'Mental Health', 'Daytrading', 'Classical Music'],
  },
  {
    uid: '6',
    gender: 0,
    birthday: new Date(2003, 12, 1),
    showMeBoys: true,
    showMeGirls: true,
    ageRangeMin: 16,
    ageRangeMax: 20,
    otherFilters: {
      Height: { options: [166, 201] },
      'Star sign': {
        options: [
          'Leo',
          'Taurus',
          'Cancer',
          'Virgo',
          'Libra',
          'Aquarius',
          'Sagittarius',
          'Scorpio',
          'Gemini',
          'Aries',
        ],
      },
      Anime: { options: [3, 5] },
    },
    personalInfo: {
      Height: 172,
      Personality: 1,
      Pets: ['Tarantula'],
      'Relationship status': 'Taken',
      'Star sign': 'Cancer',
      Religion: 'Islam',
      'K-Pop': 1,
      Anime: 5,
    },
    interests: [
      'Hacking',
      'Baseball',
      'Zoology',
      'Industrial Design',
      'Hedonism',
      'Political Science',
      'Sexual Health',
      'South America',
      'Buddhism',
      'Korea',
      "Drum'n'Bass",
      'Capitalism',
      'Neuroscience',
      'Cognitive Science',
      'Meteorology',
      'Logic',
      'Performing Arts',
      'Telecom',
      'Financial planning',
    ],
  },
  {
    uid: '7',
    gender: 0,
    birthday: new Date(2003, 12, 1),
    showMeBoys: false,
    showMeGirls: true,
    ageRangeMin: 17,
    ageRangeMax: 18,
    otherFilters: {},
    personalInfo: {
      Height: 144,
      Personality: 1,
      Pets: ['Fish', 'Tarantula'],
      'Relationship status': 'Single',
      'Star sign': 'Capricorn',
      Religion: 'Buddhism',
      'K-Pop': 2,
      Anime: 1,
    },
    interests: [
      'Chemistry',
      'Subculture',
      'Tattoos/Piercing',
      'Insurance',
      'Library Resources',
      'Neuroscience',
      'Funk',
      'Shopping',
      'Acting',
      'Basketball',
    ],
  },
  {
    uid: '8',
    gender: 0,
    birthday: new Date(2005, 12, 1),
    showMeBoys: true,
    showMeGirls: false,
    ageRangeMin: 14,
    ageRangeMax: 18,
    otherFilters: {
      Pets: { options: ['Cat', 'Hamster'], method: 1 },
      'Relationship status': { options: ['Taken'] },
      'Star sign': {
        options: ['Pisces', 'Leo', 'Cancer', 'Gemini', 'Libra', 'Aquarius'],
      },
      Religion: { options: ['Buddhism'] },
    },
    personalInfo: {
      Height: 147,
      Personality: 3,
      Pets: [],
      'Relationship status': 'Single',
      'Star sign': 'Scorpio',
      Religion: 'Islam',
      'K-Pop': 2,
      Anime: 4,
    },
    interests: [
      'TripHop/Downtempo',
      'Consumer Info',
      'Family',
      'New York',
      'Islam',
      'Motorcycles',
      'Computer Security',
      'Liberties/Rights',
      'Nursing',
      'House music',
      'Multimedia',
    ],
  },
  {
    uid: '9',
    gender: 0,
    birthday: new Date(2003, 12, 1),
    showMeBoys: false,
    showMeGirls: false,
    ageRangeMin: 18,
    ageRangeMax: 18,
    otherFilters: {},
    personalInfo: {
      Height: 189,
      Personality: 3,
      Pets: [],
      'Relationship status': 'Taken',
      'Star sign': 'Scorpio',
      Religion: 'Hinduism',
      'K-Pop': 5,
      Anime: 2,
    },
    interests: [
      'Socialism',
      'Terrorism',
      'Transportation',
      'Protestant',
      'Spain',
      'Celebrities',
      'Cyberculture',
      'Windsurfing',
      'Nightlife',
      'Alternative Rock',
      'Classic Films',
      'Sexual Health',
    ],
  },
  {
    uid: '10',
    gender: 0,
    birthday: new Date(2002, 12, 1),
    showMeBoys: false,
    showMeGirls: true,
    ageRangeMin: 17,
    ageRangeMax: 19,
    otherFilters: {
      Personality: { options: [3, 3] },
      'Relationship status': { options: ['Taken'] },
      'Star sign': { options: ['Scorpio', 'Capricorn'] },
    },
    personalInfo: {
      Height: 152,
      Personality: 3,
      Pets: ['Dog', 'Donkey', 'Fish'],
      'Relationship status': 'Single',
      'Star sign': 'Taurus',
      Religion: 'Christianity',
      'K-Pop': 2,
      Anime: 4,
    },
    interests: [
      'Anime',
      'Scrapbooking',
      'Alternative Rock',
      'Canada',
      'Mormon',
      'Environment',
      'Family',
      'Music Composition',
      'Radio Broadcasts',
      'Ergonomics',
      'Cricket',
      'Tea',
      'Animals',
      'Russia',
      'Buddhism',
    ],
  },
  {
    uid: '11',
    gender: 0,
    birthday: new Date(2003, 12, 1),
    showMeBoys: false,
    showMeGirls: true,
    ageRangeMin: 17,
    ageRangeMax: 18,
    otherFilters: {},
    personalInfo: {
      Height: 155,
      Personality: 5,
      Pets: ['Cat'],
      'Relationship status': 'Taken',
      'Star sign': 'Leo',
      Religion: 'Christianity',
      'K-Pop': 1,
      Anime: 3,
    },
    interests: [
      'Computers',
      'Extreme Sports',
      'Classic Films',
      'Capitalism',
      'Psychology',
      'Catholic',
      'Homeschooling',
      'Puzzles',
      'Satire',
      'Marketing',
      'Zoology',
      'Lounge Music',
      'Conspiracies',
      'Comic Books',
      'Bargains/Coupons',
      'Technology',
      'Homebrewing',
    ],
  },
  {
    uid: '12',
    gender: 1,
    birthday: new Date(2004, 12, 1),
    showMeBoys: true,
    showMeGirls: false,
    ageRangeMin: 17,
    ageRangeMax: 18,
    otherFilters: {},
    personalInfo: {
      Height: 140,
      Personality: 4,
      Pets: ['Fish'],
      'Relationship status': 'Taken',
      'Star sign': 'Sagittarius',
      Religion: 'Christianity',
      'K-Pop': 2,
      Anime: 1,
    },
    interests: [
      'Mexico',
      'Biotech',
      'Economics',
      'Crafts',
      'Gardening',
      'Perl',
      'Transportation',
      "DJ's/Mixing",
      'Rugby',
      'Canada',
      'Motor Sports',
      'Daytrading',
      'Germany',
      'Learning Disorders',
      'Collecting',
      'Counterculture',
      'Military',
    ],
  },
  {
    uid: '13',
    gender: 1,
    birthday: new Date(2004, 12, 1),
    showMeBoys: true,
    showMeGirls: false,
    ageRangeMin: 17,
    ageRangeMax: 17,
    otherFilters: {
      Pets: { options: ['Donkey'], method: 2 },
      'Relationship status': { options: ['Single', 'Taken'] },
      Religion: { options: ['Buddhism', 'Hinduism', 'Christianity', 'Islam'] },
      'K-Pop': { options: [2, 5] },
    },
    personalInfo: {
      Height: 163,
      Personality: 4,
      Pets: ['Donkey'],
      'Relationship status': 'Taken',
      'Star sign': 'Cancer',
      Religion: 'Christianity',
      'K-Pop': 4,
      Anime: 5,
    },
    interests: [
      'Landscaping',
      'Futurism',
      'Rugby',
      'Investing',
      'Television',
      'Shakespeare',
      'New York',
      'Trance',
      'Figure Skating',
      'Oldies Music',
      'Mobile Computing',
      'Radio Broadcasts',
      'Canada',
      'Marine Biology',
    ],
  },
  {
    uid: '14',
    gender: 0,
    birthday: new Date(2004, 12, 1),
    showMeBoys: false,
    showMeGirls: true,
    ageRangeMin: 14,
    ageRangeMax: 19,
    otherFilters: {},
    personalInfo: {
      Height: 148,
      Personality: 4,
      Pets: ['Hamster', 'Dog', 'Tarantula'],
      'Relationship status': 'Single',
      'Star sign': 'Cancer',
      Religion: 'Islam',
      'K-Pop': 5,
      Anime: 3,
    },
    interests: [
      'Computer Graphics',
      'Liberties/Rights',
      'Machinery',
      'Postmodernism',
      'Anarchism',
      'Europe',
      'Classic Rock',
      'Fishing',
      'Radio Broadcasts',
      'Physics',
      'Home Business',
      'Literature',
      'Hinduism',
      'Real Estate',
    ],
  },
  {
    uid: '15',
    gender: 1,
    birthday: new Date(2005, 12, 1),
    showMeBoys: false,
    showMeGirls: false,
    ageRangeMin: 13,
    ageRangeMax: 17,
    otherFilters: {},
    personalInfo: {
      Height: 164,
      Personality: 1,
      Pets: ['Dog'],
      'Relationship status': 'Taken',
      'Star sign': 'Virgo',
      Religion: 'Islam',
      'K-Pop': 4,
      Anime: 3,
    },
    interests: ['Industrial Design', "Drum'n'Bass"],
  },
  {
    uid: '16',
    gender: 1,
    birthday: new Date(2004, 12, 1),
    showMeBoys: true,
    showMeGirls: false,
    ageRangeMin: 15,
    ageRangeMax: 17,
    otherFilters: {
      Personality: { options: [2, 4] },
      'Relationship status': { options: ['Single', 'Taken'] },
      'Star sign': { options: ['Virgo', 'Capricorn', 'Cancer'] },
      Religion: { options: ['Christianity'] },
      Anime: { options: [2, 5] },
    },
    personalInfo: {
      Height: 189,
      Personality: 2,
      Pets: ['Dog', 'Serpent', 'Cat'],
      'Relationship status': 'Single',
      'Star sign': 'Libra',
      Religion: 'Hinduism',
      'K-Pop': 2,
      Anime: 2,
    },
    interests: [
      'Ethnic Music',
      'Matchmaking',
      'Insurance',
      'Motor Sports',
      'Divorce',
      'Gymnastics',
      'Feminism',
      'Windsurfing',
    ],
  },
  {
    uid: '17',
    gender: 1,
    birthday: new Date(2002, 12, 1),
    showMeBoys: true,
    showMeGirls: false,
    ageRangeMin: 16,
    ageRangeMax: 20,
    otherFilters: {
      Personality: { options: [3, 3] },
      'Star sign': {
        options: [
          'Taurus',
          'Pisces',
          'Capricorn',
          'Aquarius',
          'Sagittarius',
          'Virgo',
          'Libra',
        ],
      },
      Religion: { options: ['Islam', 'Hinduism', 'Buddhism', 'Christianity'] },
      Anime: { options: [2, 3] },
    },
    personalInfo: {
      Height: 162,
      Personality: 1,
      Pets: ['Dog'],
      'Relationship status': 'Taken',
      'Star sign': 'Aquarius',
      Religion: 'Islam',
      'K-Pop': 4,
      Anime: 3,
    },
    interests: [
      'Mental Health',
      'Hiking',
      'Nuclear Science',
      'Ambient Music',
      'Electronica/IDM',
      'Astronomy',
      'Video Equipment',
      'Funk',
      'Britpop',
    ],
  },
  {
    uid: '18',
    gender: 1,
    birthday: new Date(2003, 12, 1),
    showMeBoys: false,
    showMeGirls: false,
    ageRangeMin: 17,
    ageRangeMax: 18,
    otherFilters: {},
    personalInfo: {
      Height: 154,
      Personality: 3,
      Pets: ['Hamster'],
      'Relationship status': 'Single',
      'Star sign': 'Sagittarius',
      Religion: 'Christianity',
      'K-Pop': 2,
      Anime: 1,
    },
    interests: [
      'Board Games',
      'Photoshop',
      'Cheerleading',
      'HipHop/Rap',
      'Geography',
      'Video Games',
      'Film Noir',
      'Memorabilia',
      'Civil Engineering',
      'Musicals',
      'Physical Therapy',
      'Russia',
      'MacOS',
      'Advertising',
      'Logic',
    ],
  },
  {
    uid: '19',
    gender: 0,
    birthday: new Date(2002, 12, 1),
    showMeBoys: true,
    showMeGirls: false,
    ageRangeMin: 19,
    ageRangeMax: 21,
    otherFilters: {
      Height: { options: [163, 193] },
      'Star sign': { options: ['Sagittarius'] },
    },
    personalInfo: {
      Height: 177,
      Personality: 4,
      Pets: ['Donkey', 'Dog', 'Hamster'],
      'Relationship status': 'Taken',
      'Star sign': 'Cancer',
      Religion: 'Buddhism',
      'K-Pop': 3,
      Anime: 3,
    },
    interests: [
      'Electronic Parts',
      'Cult Films',
      'Coffee',
      'Dance Music',
      'Programming',
      'Puzzles',
      'New Age',
      'Jazz',
      'Linguistics',
      'Pop music',
      'Cell Phones',
      'Bird Watching',
      'Dentistry',
      'Business',
      'Zoology',
    ],
  },
  {
    uid: '20',
    gender: 1,
    birthday: new Date(2004, 12, 1),
    showMeBoys: true,
    showMeGirls: false,
    ageRangeMin: 14,
    ageRangeMax: 17,
    otherFilters: {},
    personalInfo: {
      Height: 157,
      Personality: 2,
      Pets: ['Tarantula', 'Hamster', 'Dog'],
      'Relationship status': 'Single',
      'Star sign': 'Sagittarius',
      Religion: 'Buddhism',
      'K-Pop': 4,
      Anime: 1,
    },
    interests: [
      'Gardening',
      'Puzzles',
      'Painting',
      'Petroleum',
      'Survivalist',
      'Ecommerce',
      'Musicals',
      'News(General)',
      'UK',
      'Alternative News',
      'Japan',
      'Supercomputing',
      'Clothing',
      'Restaurants',
      'American History',
    ],
  },
  {
    uid: '21',
    gender: 0,
    birthday: new Date(2004, 12, 1),
    showMeBoys: false,
    showMeGirls: true,
    ageRangeMin: 17,
    ageRangeMax: 17,
    otherFilters: {},
    personalInfo: {
      Height: 181,
      Personality: 5,
      Pets: ['Hamster', 'Cat', 'Tarantula'],
      'Relationship status': 'Single',
      'Star sign': 'Taurus',
      Religion: 'Buddhism',
      'K-Pop': 1,
      Anime: 4,
    },
    interests: ["Men's Issues", 'Europe'],
  },
  {
    uid: '22',
    gender: 0,
    birthday: new Date(2003, 12, 1),
    showMeBoys: false,
    showMeGirls: true,
    ageRangeMin: 14,
    ageRangeMax: 19,
    otherFilters: {},
    personalInfo: {
      Height: 176,
      Personality: 2,
      Pets: [],
      'Relationship status': 'Single',
      'Star sign': 'Leo',
      Religion: 'Buddhism',
      'K-Pop': 3,
      Anime: 2,
    },
    interests: ['Romance Novels', 'Food/Cooking'],
  },
  {
    uid: '23',
    gender: 1,
    birthday: new Date(2005, 12, 1),
    showMeBoys: true,
    showMeGirls: false,
    ageRangeMin: 12,
    ageRangeMax: 17,
    otherFilters: {},
    personalInfo: {
      Height: 181,
      Personality: 4,
      Pets: [],
      'Relationship status': 'Taken',
      'Star sign': 'Aquarius',
      Religion: 'Christianity',
      'K-Pop': 1,
      Anime: 5,
    },
    interests: [],
  },
  {
    uid: '24',
    gender: 0,
    birthday: new Date(2005, 12, 1),
    showMeBoys: false,
    showMeGirls: true,
    ageRangeMin: 15,
    ageRangeMax: 16,
    otherFilters: {},
    personalInfo: {
      Height: 172,
      Personality: 5,
      Pets: ['Donkey'],
      'Relationship status': 'Taken',
      'Star sign': 'Cancer',
      Religion: 'Islam',
      'K-Pop': 3,
      Anime: 2,
    },
    interests: [
      'Encryption',
      'Dolls/Puppets',
      'Nanotech',
      'Hinduism',
      'Hedonism',
      'Running',
    ],
  },
];
