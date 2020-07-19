import random

from faker import Faker

from data_generator.utils import convert_birthday_date
from data_generator.users import get_random_user_ids


def get_all_profiles(cursor):
    sql = 'SELECT * FROM profiles'
    cursor.reset()
    cursor.execute(sql)
    return cursor.fetchall()


def get_profile_ids(profiles):
    return [profile[0] for profile in profiles]


def get_all_profiles_ids(cursor):
    sql = 'SELECT id from profiles'
    cursor.reset()
    cursor.execute(sql)
    result = [row   [0] for row in cursor.fetchall()]
    return result


def generate_profiles(profiles_count):
    fake = Faker('ru_RU')
    profiles = []
    for _ in range(profiles_count):
        gender = random.randint(0, 1)
        if gender == 0:
            name = fake.name_male()
        else:
            name = fake.name_female()
        birthday = convert_birthday_date(fake.date_of_birth(minimum_age=18, maximum_age=115))
        hometown = fake.city()
        profiles.append((gender, name, birthday, hometown))
    result = list(zip(*profiles))
    return result


def add_profiles(cursor, users_ids):
    count = len(users_ids)
    profiles = generate_profiles(count)
    values = list(zip(users_ids, *profiles))
    sql = "INSERT INTO profiles (user_id, gender, name, birthday, hometown) VALUES (%s, %s, %s, %s, %s)"
    cursor.executemany(sql, values)


def add_random_profiles(cursor, profiles_count):
    users_ids = get_random_user_ids(cursor, profiles_count)
    profiles = generate_profiles(profiles_count)
    values = list(zip(users_ids, *profiles))
    sql = "INSERT INTO profiles (user_id, gender, name, birthday, hometown) VALUES (%s, %s, %s, %s, %s)"
    cursor.executemany(sql, values)


def get_profiles_count(cursor):
    sql = 'SELECT COUNT(id) from profiles'
    cursor.execute(sql)
    return cursor.fetchone()[0]


def get_random_profiles_ids(cursor, count):
    sql = f'SELECT id FROM profiles ORDER BY RAND () LIMIT {count}'
    cursor.execute(sql)
    result = [row[0] for row in cursor.fetchall()]
    return result
