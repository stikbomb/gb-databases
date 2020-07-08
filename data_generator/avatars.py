from .utils import generate_random_file
from .profiles import get_random_profiles_ids


def generate_avatars(avatars_count):
    avatars = [f'{generate_random_file()}.jpg' for _ in range(avatars_count)]
    return avatars


def add_avatars(cursor, avatars_count):
    avatars = generate_avatars(avatars_count)
    profiles_ids = get_random_profiles_ids(cursor, avatars_count)

    values = list(zip(profiles_ids, avatars))

    sql = "INSERT INTO avatars (profile_id, path) VALUES (%s, %s)"

    cursor.executemany(sql, values)
