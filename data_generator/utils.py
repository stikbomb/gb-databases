import random
from datetime import date

import mysql.connector


def get_db_connection(host, username, password, database):
    db = mysql.connector.connect(
        host=host,
        user=username,
        password=password,
        database=database
    )
    return db


def generate_random_file():
    symbols = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    result = ''.join(random.choice(symbols) for _ in range(25))
    return result


def convert_birthday_date(faker_date):
    year, month, day = str(faker_date).split('-')
    return date(int(year), int(month), int(day))


def check_repost():
    if random.randint(0, 10) == 7:
        return True
    else:
        return False
