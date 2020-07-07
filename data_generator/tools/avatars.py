import random

from .utils import generate_random_file


def generate_avatars(profile_ids, avatars_count):
    avatars = []
    profile_ids_with_avatar = random.sample(profile_ids, avatars_count)

    for profile_id in profile_ids_with_avatar:
        avatar = f'{generate_random_file()}.jpg'
        avatars.append((profile_id, avatar))
    return avatars


def add_avatars(cursor, profile_ids, avatars_count):
    avatars = generate_avatars(profile_ids, avatars_count)
    sql = "INSERT INTO avatars (profile_id, path) VALUES (%s, %s)"

    cursor.executemany(sql, avatars)
