from faker import Faker

from data_generator.profiles import get_random_profiles_ids
from data_generator.posts import get_random_posts_ids


def get_random_post_id():
    pass


def generate_comments(comments_count):
    fake = Faker('ru_RU')
    comments = [fake.text() for _ in range(comments_count)]

    return comments


def add_comments(cursor, posts_count):
    sql = 'INSERT INTO comments (profile_id, post_id, body) VALUES (%s, %s, %s)'
    profiles_ids = get_random_profiles_ids(cursor, posts_count)
    posts_ids = get_random_posts_ids(cursor, posts_count)
    comments = generate_comments(posts_count)
    values = list(zip(profiles_ids, posts_ids, comments))
    cursor.executemany(sql, values)
