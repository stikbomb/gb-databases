import random

from faker import Faker

from data_generator.tools.utils import check_repost


def get_all_posts_ids(cursor):
    cursor.reset()
    sql = 'SELECT id FROM posts'
    cursor.execute(sql)
    row = cursor.fetchall()
    result = list(sum(row, ()))
    return result


def get_random_post_id():
    pass


def generate_posts(profiles_ids, posts_count):
    fake = Faker('ru_RU')
    posts = []
    for _ in range(posts_count):
        profile_id = random.choice(profiles_ids)
        body = fake.text()

        posts.append((profile_id, body))

    return posts


def add_posts(cursor, profiles_ids, posts_count):
    sql = 'INSERT INTO posts (profile_id, body) VALUES (%s, %s)'
    posts = generate_posts(profiles_ids, posts_count)
    cursor.executemany(sql, posts)
