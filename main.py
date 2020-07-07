import os

from dotenv import load_dotenv


from data_generator.tools.utils import get_db_connection, generate_random_file
from data_generator.tools.users import get_all_users, add_users, get_user_ids, get_random_user_ids
from data_generator.tools.profiles import add_profiles, get_all_profiles, get_profile_ids
from data_generator.tools.avatars import add_avatars
from data_generator.tools.messages import add_messages

import data_generator.tools.utils as utils


if __name__ == '__main__':
    user_count = 1000


    load_dotenv()
    host = os.getenv('HOST')
    username = os.getenv('LOGIN')
    password = os.getenv('PASSWORD')
    database = os.getenv('DATABASE')

    database = get_db_connection(host, username, password, database)
    cursor = database.cursor()

    add_users(cursor, user_count)
    database.commit()

    users = get_all_users(cursor)

    user_ids = get_user_ids(users)
    print(user_ids)
    add_profiles(cursor, user_ids)
    database.commit()

    random_user_ids = get_random_user_ids(user_ids, 3)
    add_profiles(cursor, random_user_ids)
    database.commit()

    add_messages(cursor, user_ids, 1000)
    database.commit()

    profiles = get_all_profiles(cursor)
    profile_ids = get_profile_ids(profiles)
    add_avatars(cursor, profile_ids)
    database.commit()
