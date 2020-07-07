import random

from faker import Faker

from data_generator.tools.utils import convert_birthday_date


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
    return cursor.fetchall()


def generate_profiles(user_ids):
    fake = Faker('ru_RU')
    profiles = []
    for user_id in user_ids:
        gender = random.randint(0, 1)
        if gender == 0:
            name = fake.name_male()
        else:
            name = fake.name_female()
        birthday = convert_birthday_date(fake.date_of_birth(minimum_age=18, maximum_age=115))
        hometown = fake.city()
        profiles.append((user_id, gender, name, birthday, hometown))
    return profiles


def add_profiles(cursor, users_id):
    profiles = generate_profiles(users_id)
    sql = "INSERT INTO profiles (user_id, gender, name, birthday, hometown) VALUES (%s, %s, %s, %s, %s)"
    cursor.executemany(sql, profiles)
