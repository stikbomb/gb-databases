import random

from .profiles import get_all_profiles_ids


def get_request_statuses(count):
    statuses = ['requested', 'approved', 'unfriended', 'declined']

    return [random.choice(statuses) for _ in range(count)]


def generate_friend_requests(profiles_ids, max_friends_per_profile):

    result = []

    if max_friends_per_profile > len(profiles_ids):
        max_friends_per_profile = len(profiles_ids)

    for profile in profiles_ids:
        count = random.randrange(max_friends_per_profile)
        requested_profiles = random.sample(profiles_ids, count)
        request_statuses = get_request_statuses(count)

        requests = zip(requested_profiles, request_statuses)

        for request in requests:
            result.append((profile, request[0], request[1]))

    return result


def add_friend_requests(cursor, max_friend_requests_per_profile: int):

    profiles = get_all_profiles_ids(cursor)
    requests = generate_friend_requests(profiles, max_friend_requests_per_profile)
    sql = "INSERT INTO friend_requests (initiator_profile_id, target_profile_id, status) VALUES (%s, %s, %s)"
    cursor.executemany(sql, requests)
