import random
import time

import redis


def get_random_digit():
    return random.randint(0, 255)


def get_random_ip():
    return f'{get_random_digit()}.{get_random_digit()}.{get_random_digit()}.{get_random_digit()}'


def get_ip_pool(ip_count):
    result = []
    for _ in range(ip_count):
        new_ip = get_random_ip()
        if new_ip in result:
            continue
        result.append(new_ip)

    return result


# def get_random_time():
#     return


def fill_db(ips, count):
    # time is 01/01/2020 @ 12:00am (UTC)
    time = 1577836800
    r = redis.Redis()
    for _ in range(count):
        ip = random.choice(ips)
        time = time + random.randint(0, 100)
        r.pfadd(ip, time)


def show_random_ip(ip):
    r = redis.Redis()

    return r.pfcount(ip)


if __name__ == '__main__':
    ips = get_ip_pool(10)
    print(time.time())
    fill_db(ips, 1000000)
    print(time.time())
    print(show_random_ip(ips[0]))
    print(time.time())