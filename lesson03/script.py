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


def add_users(db, users_count):
    cursor = db.cursor()
    fake = Faker('ru_RU')
    sql = "INSERT INTO users (login, email, phone) VALUES (%s, %s, %s)"
    users = []
    for _ in range(users_count):
        login = fake.user_name()
        email = f'{login}@{fake.free_email_domain()}'
        phone = f'79{random.randint(100000000, 999999999)}'

        users.append((login, email, phone))

    # print(cursor.executemany(sql, users))

    print(db.commit())
    # print(cursor.lastrowid)
    cursor.execute("SELECT * FROM users")
    myresult = cursor.fetchall()
    print(len(myresult))

def add_profiles(db, ):
    pass


def add_messages(cursor, messages_count):
    pass



if __name__ == '__main__':
    load_dotenv()
    host = os.getenv('HOST')
    username = os.getenv('LOGIN')
    password = os.getenv('PASSWORD')

    database = 'social_network'

    print(host, username, password)
    database = get_db_connection(host, username, password, database)
    print(database.__dict__)



    print(add_users(database, 200))

    cursor = database.cursor()
