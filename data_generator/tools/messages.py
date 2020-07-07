import random

from faker import Faker


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