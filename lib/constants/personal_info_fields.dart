const Map<String, Map<String, dynamic>> personalInfoFields = {
  'School': {
    'type': 1,
    'prompt':
        'Select your school, or if youre from somewhere else enter its name',
    'options': [
      'Raffles Girls School',
      'Raffles Institution',
      'Hwa Chong Institution',
      'NUS High School',
      'Nanyang Girls High',
      'School of the Arts',
      'National Junior College',
    ],
  },
  'Height': {
    'type': 0,
    'prompt': 'Enter your height in cm',
    'options': 300,
  },
  'Weight': {
    'type': 0,
    'prompt': 'Enter your weight in kg',
    'options': 300,
  },
  'Personality': {
    'type': 2,
    'prompt':
        'On a scale of 1 to 5, how introverted or extroverted are you? (1 being introverted)',
    'options': 5,
  },
  'Pets': {
    'type': 4,
    'prompt': 'A list of your pets',
    'options': null,
  },
  'Relationship status': {
    'type': 3,
    'prompt': 'Your current relationship status',
    'options': [
      'Single',
      'Taken',
    ],
  },
  'Star sign': {
    'type': 3,
    'prompt': 'Your star sign',
    'options': [
      'Aquarius',
      'Pisces',
      'Aries',
      'Taurus',
      'Gemini',
      'Cancer',
      'Leo',
      'Virgo',
      'Libra',
      'Scorpio',
      'Sagittarius',
      'Capricorn',
    ],
  },
  'Religion': {
    'type': 1,
    'prompt': 'Select your religion, or enter its name if its not listed',
    'options': [
      'Christianity',
      'Islam',
      'Atheist',
      'Hinduism',
      'Buddhism',
      'Sikhism',
      'Judaism',
      'Taoism',
      'Confucianism',
      'Racism',
    ],
  },
  'K-Pop': {
    'type': 2,
    'prompt':
        "On a scale of 1 to 5, how much do you listen to / are you into K-Pop? (1 indicating you don't like it)",
    'options': 5,
  },
  'Anime': {
    'type': 2,
    'prompt':
        "On a scale of 1 to 5, how much do you watch / are you into anime? (1 indicating you don't like it)",
    'options': 5,
  },
  'Fetishes': {
    'type': 4,
    'prompt': 'Describe your fetish',
    'options': null,
  },
  'Typing speed': {
    'type': 0,
    'prompt': "What's your average typing speed in WPM?",
    'options': 250,
  },
};
