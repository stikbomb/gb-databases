from faker import Faker

from data_generator.utils import check_repost
from data_generator.profiles import get_random_profiles_ids


def get_all_posts_ids(cursor):
    cursor.reset()
    sql = 'SELECT id FROM posts'
    cursor.execute(sql)
    result = [row[0] for row in cursor.fetchall()]
    return result


def get_random_post_id(cursor):
    sql = 'SELECT id FROM posts  ORDER BY RAND () LIMIT 1'
    cursor.execute(sql)
    return cursor.fetchone()[0]


def generate_posts(cursor, posts_count):
    fake = Faker('ru_RU')
    posts = []
    for _ in range(posts_count):
        if check_repost():
            parent_post_id = get_random_post_id(cursor)
        else:
            parent_post_id = None
        body = fake.text()

        posts.append((body, parent_post_id))
    result = list(zip(*posts))
    return result


def add_posts(cursor, posts_count):
    sql = 'INSERT INTO posts (profile_id, body, parent_post_id) VALUES (%s, %s, %s)'
    profiles_ids = get_random_profiles_ids(cursor, posts_count)
    posts = generate_posts(cursor, posts_count)
    values = list(zip(profiles_ids, *posts))
    cursor.executemany(sql, values)


def get_random_posts_ids(cursor, posts_count):
    sql = f'SELECT id FROM posts order by RAND() LIMIT {posts_count}'
    cursor.execute(sql)
    return [row[0] for row in cursor.fetchall()]
