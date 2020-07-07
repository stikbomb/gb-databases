import random

from faker import Faker

from data_generator.tools.utils import check_repost, generate_random_file
from data_generator.tools.profiles import  get_all_profiles_ids
from data_generator.tools.posts import get_all_posts_ids


def get_random_post_id():
    pass


def generate_mediafile():
    fake = Faker('ru_RU')
    type = random.choice(['picture', 'audio', 'video'])
    filename = generate_random_file()
    if type == 'picture':
        extension = fake.file_extension(category='image')
    elif type == 'audio':
        extension = fake.file_extension(category='audio')
    else:
        extension = fake.file_extension(category='video')

    return f'{filename}.{extension}'


def generate_mediafiles(profiles_ids, files_count):
    fake = Faker('ru_RU')
    media_files = []
    for _ in range(files_count):
        profile_id = random.choice(profiles_ids)
        path = generate_mediafile()
        title = fake.sentence()
        description = fake.text()

        media_files.append((profile_id, path, title, description))

    return media_files


def add_media_files(cursor, profiles_ids, files_count):
    sql = 'INSERT INTO media_files (profile_id, path, title, description) VALUES (%s, %s, %s, %s)'
    media_files = generate_mediafiles(profiles_ids, files_count)
    cursor.executemany(sql, media_files)
