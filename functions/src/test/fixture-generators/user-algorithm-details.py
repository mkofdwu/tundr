import random

NUM_USERS = 10
userAlgorithmDetails = []

for i in range(NUM_USERS):
    userAlgorithmDetails.append({
        'uid': i.toString(),
        'gender': random.randint(0, 1),
        'birthday': ,
        'showMeBoys': bool(random.getrandbits(1)),
        'showMeGirls': bool(random.getrandbits(1)),
        # TODO
        'ageRangeMin': 10,
        'ageRangeMax': 10,
        'filters': {},
        'personalInfo': {},
        'interests': [],
    })

print(userAlgorithmDetails)
