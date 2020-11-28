import random

NUM_USERS = 10
user_algorithm_details = []

# all of them have similar birthdays

for i in range(NUM_USERS):
    has_filters = bool(random.getrandbits(1))
    user_algorithm_details.append({
        'uid': str(i),
        'gender': random.randint(0, 1),
        # 'birthday': ,
        'showMeBoys': bool(random.getrandbits(1)),
        'showMeGirls': bool(random.getrandbits(1)),
        # TODO
        'ageRangeMin': 10,
        'ageRangeMax': 10,
        'filters': {},
        'personalInfo': {},
        'interests': [],
    })

print(user_algorithm_details)
