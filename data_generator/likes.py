import random

from .posts import get_all_posts_ids, get_random_posts_ids
from .profiles import get_all_profiles_ids
from .mediafiles import get_all_mediafiles_ids


def generate_likes(profiles_ids, entities_ids, max_likes_per_profile):
    result = []

    if max_likes_per_profile > len(entities_ids):
        max_likes_per_profile = len(entities_ids)

    for profile in profiles_ids:
        count = random.randrange(max_likes_per_profile)
        liked_entities = random.sample(entities_ids, count)
        for entity in liked_entities:
            result.append((profile, entity))

    return result


def generate_profiles_likes(cursor, max_likes):
    profiles = get_all_profiles_ids(cursor)
    max_likes_per_profile = max_likes

    return generate_likes(profiles, profiles, max_likes_per_profile)


def add_profiles_likes(cursor, max_likes):
    sql = "INSERT INTO profiles_likes (profile_id, target_profile_id) VALUES (%s, %s)"
    profiles_likes = generate_profiles_likes(cursor, max_likes)
    delete_self_profiles_likes(cursor)
    cursor.executemany(sql, profiles_likes)


def delete_self_profiles_likes(cursor):
    sql = 'delete from profiles_likes where profile_id = target_profile_id'
    cursor.execute(sql)


def generate_posts_likes(cursor, max_likes):
    profiles = get_all_profiles_ids(cursor)
    posts = get_all_posts_ids(cursor)

    return generate_likes(profiles, posts, max_likes)


def add_posts_likes(cursor, max_likes):
    sql = "INSERT INTO posts_likes (profile_id, post_id) VALUES (%s, %s)"
    posts_likes = generate_posts_likes(cursor, max_likes)

    cursor.executemany(sql, posts_likes)


def generate_media_likes(cursor, max_likes):
    profiles = get_all_profiles_ids(cursor)
    mediafiles = get_all_mediafiles_ids(cursor)

    return generate_likes(profiles, mediafiles, max_likes)


def add_media_likes(cursor, max_likes):
    sql = "INSERT INTO media_files_likes (profile_id, media_file_id) VALUES (%s, %s)"
    media_likes = generate_media_likes(cursor, max_likes)

    cursor.executemany(sql, media_likes)