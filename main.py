import os
import sys

from dotenv import load_dotenv


from data_generator.tools.utils import get_db_connection
from data_generator.tools.users import get_all_users, add_users, get_user_ids, get_random_user_ids
from data_generator.tools.profiles import add_profiles, get_all_profiles, get_profile_ids, get_profiles_count
from data_generator.tools.avatars import add_avatars
from data_generator.tools.messages import add_messages
from data_generator.tools.posts import add_posts
from data_generator.tools.comments import add_comments
from data_generator.tools.mediafiles import add_media_files


if __name__ == '__main__':

    # PARAMS
    user_count = 1000
    posts_count = 10000
    comments_count = 20000
    mediafiles_count = 500
    message_count = 4000
    avatars_proportion = 0.8

    # ENVS TO DB
    load_dotenv()
    host = os.getenv('HOST')
    username = os.getenv('LOGIN')
    password = os.getenv('PASSWORD')
    database = os.getenv('DATABASE')

    # DB CONNECTION
    sys.stdout.write('Connecting to database... ')
    database = get_db_connection(host, username, password, database)
    cursor = database.cursor()
    sys.stdout.write('Done!\n')

    # ADD USERS
    sys.stdout.write(f'Adding {user_count} users... ')
    add_users(cursor, user_count)
    database.commit()
    sys.stdout.write('Done!\n')

    # ADD PROFILES TO ALL USERS
    sys.stdout.write('Adding profiles to all users... ')
    users = get_all_users(cursor)
    user_ids = get_user_ids(users)
    add_profiles(cursor, user_ids)
    database.commit()
    sys.stdout.write('Done!\n')

    # ADD RANDOM ANOTHER PROFILES
    profiles_count = int(user_count * 0.3)
    sys.stdout.write(f'Adding {profiles_count} additional profiles... ')
    random_user_ids = get_random_user_ids(user_ids, profiles_count)
    add_profiles(cursor, random_user_ids)
    database.commit()
    sys.stdout.write('Done!\n')

    # VARS TO OTHER INSERTS
    users = get_all_users(cursor)
    user_ids = get_user_ids(users)
    profiles = get_all_profiles(cursor)
    profile_ids = get_profile_ids(profiles)

    # ADD MESSAGES
    sys.stdout.write(f'Adding {message_count} messages... ')
    add_messages(cursor, user_ids, message_count)
    database.commit()
    sys.stdout.write('Done!\n')

    # ADD AVATARS
    profiles_count = get_profiles_count(cursor)
    avatars_count = int(profiles_count * avatars_proportion)
    sys.stdout.write(f'Adding {avatars_count} avatars... ')
    add_avatars(cursor, profile_ids, avatars_count)
    database.commit()
    sys.stdout.write('Done!\n')

    # ADD POSTS
    sys.stdout.write(f'Adding {posts_count} posts... ')
    add_posts(cursor, profile_ids, posts_count)
    database.commit()
    sys.stdout.write('Done!\n')

    # ADD COMMENTS
    sys.stdout.write(f'Adding {comments_count} comments... ')
    add_comments(cursor, profile_ids, comments_count)
    database.commit()
    sys.stdout.write('Done!\n')

    # ADD MEDIAFILES
    sys.stdout.write(f'Adding {mediafiles_count} mediafiles... ')
    add_media_files(cursor, profile_ids, mediafiles_count)
    database.commit()
    sys.stdout.write('Done!\n')
