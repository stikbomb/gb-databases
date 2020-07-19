import random

from .posts import get_all_posts_ids, get_random_posts_ids
from .profiles import get_all_profiles_ids
from .mediafiles import get_all_mediafiles_ids


def generate_profiles_likes(cursor):
    profiles = get_all_profiles_ids(cursor)
    result = []
    max_likes_per_profile = 200

    if max_likes_per_profile > len(profiles):
        max_likes_per_profile = len(profiles)
        
    for profile in profiles:
        count = random.randrange(max_likes_per_profile)
        liked_profiles = random.sample(profiles, count)
        for liked_profile in liked_profiles:
            result.append((profile, liked_profile))

    return result


def add_profiles_likes(cursor):
    sql = "INSERT INTO profiles_likes (profile_id, target_profile_id) VALUES (%s, %s)"
    profiles_likes = generate_profiles_likes(cursor)

    cursor.executemany(sql, profiles_likes)