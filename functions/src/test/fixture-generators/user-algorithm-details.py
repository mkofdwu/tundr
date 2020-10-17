NUM_USERS = 10
userAlgorithmDetails = []

for i in range(NUM_USERS):
  userAlgorithmDetails.append({
    'uid': i.toString(),
    'gender': 0 if Math.random() > 0.5 else 1,
    'showMeBoys': Math.random() > 0.5,
    'showMeGirls': Math.random() > 0.5,
    # TODO
    'ageRangeMin': ,
    'ageRangeMax': ,
    'filters': {},
    'personalInfo': {},
    'interests': [],
  })