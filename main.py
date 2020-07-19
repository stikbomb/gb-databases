import os
import sys

from dotenv import load_dotenv


from data_generator.utils import get_db_connection
from data_generator.users import add_users, get_random_user_ids, get_all_users_ids
from data_generator.profiles import add_profiles, get_all_profiles, get_profile_ids, get_profiles_count
from data_generator.avatars import add_avatars
from data_generator.messages import add_messages
from data_generator.posts import add_posts
from data_generator.comments import add_comments
from data_generator.mediafiles import add_media_files
from data_generator.likes import add_profiles_likes, add_posts_likes, add_media_likes

if __name__ == '__main__':

    # PARAMS
    # user_count = 1000
    # posts_count = 10000
    # comments_count = 20000
    # mediafiles_count = 500
    # message_count = 4000
    # avatars_proportion = 0.8

    user_count = 10
    posts_count = 100
    comments_count = 20
    mediafiles_count = 5
    message_count = 40
    avatars_proportion = 0.8
    max_likes_for_profiles_per_profile = 200
    max_likes_for_posts_per_profile = 200
    max_likes_for_media_per_profles = 300

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

    # # ADD USERS
    # sys.stdout.write(f'Adding {user_count} users... ')
    # add_users(cursor, user_count)
    # database.commit()
    # sys.stdout.write('Done!\n')
    #
    # # ADD PROFILES TO ALL USERS
    # sys.stdout.write('Adding profiles to all users... ')
    # users_ids = get_all_users_ids(cursor)
    # add_profiles(cursor, users_ids)
    # database.commit()
    # sys.stdout.write('Done!\n')
    #
    # # ADD RANDOM ANOTHER PROFILES
    # profiles_count = int(user_count * 0.3)
    # sys.stdout.write(f'Adding {profiles_count} additional profiles... ')
    # random_user_ids = get_random_user_ids(cursor, profiles_count)
    # add_profiles(cursor, random_user_ids)
    # database.commit()
    # sys.stdout.write('Done!\n')
    #
    # # VARS TO OTHER INSERTS
    # user_ids = get_all_users_ids(cursor)
    # profiles = get_all_profiles(cursor)
    # profile_ids = get_profile_ids(profiles)
    #
    # # ADD MESSAGES
    # sys.stdout.write(f'Adding {message_count} messages... ')
    # add_messages(cursor, message_count)
    # database.commit()
    # sys.stdout.write('Done!\n')
    #
    # # ADD AVATARS
    # # profiles_count = get_profiles_count(cursor)
    # # avatars_count = int(profiles_count * avatars_proportion)
    # # sys.stdout.write(f'Adding {avatars_count} avatars... ')
    # # add_avatars(cursor, avatars_count)
    # # database.commit()
    # # sys.stdout.write('Done!\n')
    #
    # # ADD POSTS
    # sys.stdout.write(f'Adding {posts_count} posts... ')
    # add_posts(cursor, posts_count)
    # database.commit()
    # sys.stdout.write('Done!\n')
    #
    # # ADD COMMENTS
    # sys.stdout.write(f'Adding {comments_count} comments... ')
    # add_comments(cursor, comments_count)
    # database.commit()
    # sys.stdout.write('Done!\n')
    #
    # # ADD MEDIAFILES
    # sys.stdout.write(f'Adding {mediafiles_count} mediafiles... ')
    # add_media_files(cursor, profile_ids, mediafiles_count)
    # database.commit()
    # sys.stdout.write('Done!\n')

    # # ADD PROFILES LIKES
    # sys.stdout.write(f'Maximum likes to profiles per profile {max_likes_for_profiles_per_profile}. '
    #                  f'Adding likes to profiles... ')
    # add_profiles_likes(cursor, max_likes_for_profiles_per_profile)
    # database.commit()
    # sys.stdout.write('Done!\n')

    # # ADD POSTS LIKES
    # sys.stdout.write(f'Maximum likes to posts per profile {max_likes_for_posts_per_profile}. '
    #                  f'Adding likes to posts... ')
    # add_posts_likes(cursor, max_likes_for_posts_per_profile)
    # database.commit()
    # sys.stdout.write('Done!\n')

    # ADD MEDIA LIKES
    sys.stdout.write(f'Maximum likes to media per profile {max_likes_for_media_per_profles}. '
                     f'Adding likes to media... ')
    add_media_likes(cursor, max_likes_for_media_per_profles)
    database.commit()
    sys.stdout.write('Done!\n')

