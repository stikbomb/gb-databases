import redis
from faker import Faker


def create_users(count):
    fake = Faker()
    result = []
    for _ in range(count):
        profile = fake.simple_profile()
        name = profile['username']
        email = profile['mail']
        result.append((f'{name}:{email}', name, email))

    return result


def fill_db(users):
    r = redis.Redis()
    # redis.StrictRedis(host="localhost", port=6379, charset="utf-8", decode_responses=True)
    for user in users:
        r.hset(user[0], user[1], user[2])


if __name__ == '__main__':
    r = redis.Redis()
    users = create_users(10)
    fill_db(users)
    print(users)

    print(r.keys(f'*{users[0][0]}'))
    print(r.keys(f'{users[0][1]}*'))