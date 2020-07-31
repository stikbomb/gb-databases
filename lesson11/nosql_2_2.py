import redis

from nosql_2_1 import create_users


def fill_db(users):
    r = redis.Redis()

    for user in enumerate(users):
        r.hset(user[1][1], 'id', user[0])
        r.hset(user[1][1], 'email', user[1][2])
        r.hset(user[0], 'email', user[1][2])


if __name__ == '__main__':
    users = create_users(10)
    fill_db(users)
    r = redis.StrictRedis(host="localhost", port=6379, charset="utf-8", decode_responses=True)

    user_name = users[0][1]
    user_id = r.hgetall(user_name)['id']
    user_email = r.hgetall(user_id)

    print(user_email)