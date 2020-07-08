import random

from faker import Faker

from data_generator.utils import generate_random_file


def generate_users(users_count):
    fake = Faker('ru_RU')
    users = []
    for _ in range(users_count):
        login = fake.user_name()
        password = generate_random_file()
        number = random.randint(0, 999)
        email = f'{login}{number}@{fake.free_email_domain()}'
        phone = f'79{random.randint(100000000, 999999999)}'

        users.append((login, password, email, phone))
    return users


def add_users(cursor, users_count):
    sql = "INSERT INTO users (login, password, email, phone) VALUES (%s, %s, %s, %s)"
    users = generate_users(users_count)

    cursor.executemany(sql, users)


def get_random_user_ids(cursor, count):
    sql = f'SELECT id FROM users ORDER BY RAND () LIMIT {count}'
    cursor.execute(sql)
    result = [row[0] for row in cursor.fetchall()]
    return result


def get_all_users_ids(cursor):
    sql = 'SELECT id FROM users'
    cursor.execute(sql)
    result = [row[0] for row in cursor.fetchall()]
    return result