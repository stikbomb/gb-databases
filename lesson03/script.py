import os
import random

from faker import Faker
import mysql.connector
from dotenv import load_dotenv


def get_db_connection(host, username, password, database):
    db = mysql.connector.connect(
        host=host,
        user=username,
        password=password,
        database=database
    )
    return db


def generate_users(users_count):
    fake = Faker('ru_RU')
    users = []
    for _ in range(users_count):
        login = fake.user_name()
        email = f'{login}@{fake.free_email_domain()}'
        phone = f'79{random.randint(100000000, 999999999)}'

        users.append((login, email, phone))
    return users


def add_users(cursor, users_count):
    sql = "INSERT INTO users (login, email, phone) VALUES (%s, %s, %s)"
    users = generate_users(users_count)

    cursor.executemany(sql, users)


def get_all_users(cursor):
    sql = 'SELECT * FROM users'
    cursor.execute(sql)
    return cursor.fetchall()


def get_random_user_ids(users_ids, count):
    return random.sample(users_ids, count)


def get_user_ids(users):
    return [user[0] for user in users]


def get_all_profiles(cursor):
    sql = 'SELECT * FROM profiles'
    cursor.execute(sql)
    return cursor.fetchall()


def get_profile_ids(profiles):
    return [profile[0] for profile in profiles]


def generate_random_files():
    symbols = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    result = ''.join(random.choice(symbols) for _ in range(25))
    return result


def generate_avatars(profile_ids):
    proportion = 0.9
    avatars = []
    profile_ids_with_avatar_count = int(len(profile_ids) * proportion)
    profile_ids_with_avatar = random.sample(profile_ids, profile_ids_with_avatar_count)
    for profile_id in profile_ids_with_avatar:
        avatar = f'{generate_random_files()}.jpg'
        avatars.append((profile_id, avatar))
    return avatars


def add_avatars(cursor, profile_ids):
    avatars = generate_avatars(profile_ids)
    sql = "INSERT INTO avatars (profile_id, path) VALUES (%s, %s)"

    cursor.executemany(sql, avatars)


def generate_profiles(user_ids):
    fake = Faker('ru_RU')
    profiles = []
    for user_id in user_ids:
        gender = random.randint(0, 1)
        if gender == 0:
            name = fake.name_male()
        else:
            name = fake.name_female()
        birthday = fake.date_of_birth(minimum_age=18, maximum_age=115)
        hometown = fake.city()
        profiles.append((user_id, gender, name, birthday, hometown))
    return profiles


def add_profiles(cursor, users_id):
    profiles = generate_profiles(users_id)
    sql = "INSERT INTO profiles (user_id, gender, name, birthday, hometown) VALUES (%s, %s, %s, %s, %s)"
    cursor.executemany(sql, profiles)


def generate_messages(user_ids, messages_count):
    fake = Faker('ru_RU')
    messages = []
    for _ in range(messages_count):
        from_profile_id, to_profile_id = random.sample(user_ids, 2)
        message = fake.text()
        messages.append((from_profile_id, to_profile_id, message))

    return messages


def add_messages(cursor, user_ids, messages_count):
    messages = generate_messages(user_ids, messages_count)
    sql = "INSERT INTO messages (from_profile_id, to_profile_id, body) VALUES (%s, %s, %s)"

    cursor.executemany(sql, messages)


if __name__ == '__main__':
    load_dotenv()
    host = os.getenv('HOST')
    username = os.getenv('LOGIN')
    password = os.getenv('PASSWORD')
    database = os.getenv('DATABASE')

    database = get_db_connection(host, username, password, database)
    cursor = database.cursor()

    # add_users(cursor, 200)
    # database.commit()

    users = get_all_users(cursor)

    user_ids = get_user_ids(users)
    # add_profiles(cursor, user_ids)
    # database.commit()

    random_user_ids = get_random_user_ids(user_ids, 33)
    # add_profiles(cursor, random_user_ids)
    # database.commit()

    # add_messages(cursor, user_ids, 10000)
    # database.commit()

    # print(generate_random_files())

    profiles = get_all_profiles(cursor)
    profile_ids = get_profile_ids(profiles)
    add_avatars(cursor, profile_ids)
    database.commit()