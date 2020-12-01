import random
import datetime

from constants import *

NUM_USERS = 10
user_algorithm_details = []


class FilterMethod:
    none = 0
    if_contains_all = 1
    if_contains_any = 2


def b(): return bool(random.getrandbits(1))


def random_filters():
    height_preference = b()
    personality_preference = b()
    pet_preference = b()
    status_preference = b()
    star_sign_preference = b()
    religion_preference = b()
    kpop_preference = b()
    anime_preference = b()
    min_height = random.randrange(150, 180)
    max_height = min_height + random.randrange(10, 50)

    filters = {
        'Height': {'options': [min_height, max_height]} if height_preference else None,
        'Personality': {'options': [random.randint(1, 3), random.randint(3, 5)]} if personality_preference else None,
        'Pets': {
            'options': [],  # TODO
            'method': random.randint(1, 2),
        } if pet_preference else None,
        'Relationship status': {'options': random.choices(['Single', 'Taken'], k=random.randint(0, 2))} if status_preference else None,
        'Star sign': {'options': random.choices(STAR_SIGNS, k=random.randint(1, 12))} if star_sign_preference else None,
        'Religion': {'options': random.choices(RELIGIONS, k=random.randint(1, 4))} if religion_preference else None,
        'K-Pop': {'options': [random.randint(1, 3), random.randint(3, 5)]} if kpop_preference else None,
        'Anime': {'options': [random.randint(1, 3), random.randint(3, 5)]} if anime_preference else None,
    }

    return filters


def random_personal_info():
    return {
        'Height': random.randrange(140, 200),
        'Personality': random.randint(1, 5),
        'Pets': random.choices(PETS, k=random.randint(0, 3)),
        'Relationship status': random.choice(['Single', 'Taken']),
        'Star sign': random.choice(STAR_SIGNS),
        'Religion': random.choice(RELIGIONS),
        'K-Pop': random.randint(1, 5),
        'Anime': random.randint(1, 5),
    }


for i in range(NUM_USERS):
    has_filters = b()
    age = random.randrange(15, 19)
    now = datetime.datetime.now()
    user_algorithm_details.append({
        'uid': str(i),
        'gender': random.randint(0, 1),
        'birthday': f'new Date({now.year - age}, {now.month}, {now.day})',
        'showMeBoys': b(),
        'showMeGirls': b(),
        'ageRangeMin': age - random.randrange(-1, 4),
        'ageRangeMax': age + random.randrange(1, 4),
        'filters': random_filters() if has_filters else {},
        'personalInfo': random_personal_info(),
        'interests': random.choices(INTERESTS, k=random.randrange(0, 20)),
    })

print(user_algorithm_details)
