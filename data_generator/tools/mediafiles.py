import random

from faker import Faker

from data_generator.tools.utils import check_repost, generate_random_file
from data_generator.tools.profiles import  get_all_profiles_ids
from data_generator.tools.posts import get_all_posts_ids


def get_random_post_id():
    pass

def generate_mediafile():
    fake = Faker('ru_RU')
    type = random.choice('picture', 'audio', 'video')
    filename = generate_random_file()
    if type == 'picture':
        extension = 
    elif type == 'audio':
        pass
    else:
        pass

def generate_mediafiles(profiles_ids, files_count):
    fake = Faker('ru_RU')
    media_files = []
    for _ in range(files_count):
        profile_id = random.choice(profiles_ids)
        post_id = random.choice(posts_ids)
        body = fake.text()

        comments.append((profile_id, post_id, body))

    return comments


def add_comments(cursor, profiles_ids, posts_count):
    sql = 'INSERT INTO comments (profile_id, post_id, body) VALUES (%s, %s, %s)'
    posts_ids = get_all_posts_ids(cursor)
    print(posts_ids)
    comments = generate_comments(profiles_ids, posts_ids, posts_count)
    print(comments)
    cursor.executemany(sql, comments)
