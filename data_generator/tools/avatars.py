import random

from .utils import generate_random_file


def generate_avatars(profile_ids):
    proportion = 0.9
    avatars = []
    profile_ids_with_avatar_count = int(len(profile_ids) * proportion)
    profile_ids_with_avatar = random.sample(profile_ids, profile_ids_with_avatar_count)
    for profile_id in profile_ids_with_avatar:
        avatar = f'{generate_random_file()}.jpg'
        avatars.append((profile_id, avatar))
    return avatars


def add_avatars(cursor, profile_ids):
    avatars = generate_avatars(profile_ids)
    sql = "INSERT INTO avatars (profile_id, path) VALUES (%s, %s)"

    cursor.executemany(sql, avatars)
