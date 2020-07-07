import random

from faker import Faker

from data_generator.posts import get_all_posts_ids


def get_random_post_id():
    pass


def generate_comments(profiles_ids, posts_ids, comments_count):
    fake = Faker('ru_RU')
    comments = []
    for _ in range(comments_count):
        profile_id = random.choice(profiles_ids)
        post_id = random.choice(posts_ids)
        body = fake.text()

        comments.append((profile_id, post_id, body))

    return comments


def add_comments(cursor, profiles_ids, posts_count):
    sql = 'INSERT INTO comments (profile_id, post_id, body) VALUES (%s, %s, %s)'
    posts_ids = get_all_posts_ids(cursor)
    comments = generate_comments(profiles_ids, posts_ids, posts_count)
    cursor.executemany(sql, comments)
