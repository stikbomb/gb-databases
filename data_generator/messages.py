from faker import Faker

from data_generator.profiles import get_random_user_ids


def generate_messages(messages_count):
    fake = Faker('ru_RU')
    messages = [fake.text() for _ in range(messages_count)]

    return messages


def add_messages(cursor, messages_count):
    from_profile_id = get_random_user_ids(cursor, messages_count)
    to_profile_id = get_random_user_ids(cursor, messages_count)
    messages = generate_messages(messages_count)
    values = list(zip(from_profile_id, to_profile_id, messages))
    sql = "INSERT INTO messages (from_profile_id, to_profile_id, body) VALUES (%s, %s, %s)"
    cursor.executemany(sql, values)