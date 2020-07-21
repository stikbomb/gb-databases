use social_network;

-- Определить кто больше поставил лайков (всего) - мужчины или женщины? (ВАРИАНТ 1)

SELECT COUNT(*)            AS total
     , SUM(CASE
               WHEN profile_id in
                    (select profile_id from (
                                    select * from posts_likes
                                    union all
                                    select * from profiles_likes
                                    union all
                                    select * from media_files_likes
                                        ) as t where profile_id in (select id from profiles where gender like '0')) THEN 1
               ELSE 0 END) AS male
     , SUM(CASE
               WHEN profile_id in
                    (select profile_id from (
                                    select * from posts_likes
                                    union all
                                    select * from profiles_likes
                                    union all
                                    select * from media_files_likes
                                        ) as t where profile_id in (select id from profiles where gender like '1')) THEN 1
               ELSE 0 END) AS female
FROM (select profile_id from (
                                    select * from posts_likes
                                    union all
                                    select * from profiles_likes
                                    union all
                                    select * from media_files_likes
                                        ) as u) as y;

-- для удобства создадим общую таблицу лайков, чтобы не тянуть в каждый запрос тройное объединение

create table meta_likes (
                                    select profile_id, 'post' as `type` from posts_likes
                                    union all
                                    select profile_id, 'profile' as `tyoe` from profiles_likes
                                    union all
                                    select profile_id, 'media' as `type` from media_files_likes
                                        );
drop table meta_likes;

-- Определить кто больше поставил лайков (всего) - мужчины или женщины? (ВАРИАНТ 2)

select (select count(*) from meta_likes) as total,
(select count(*) from meta_likes where profile_id in (select id from profiles where gender = '0')) as male,
(select count(*) from meta_likes where profile_id in (select id from profiles where gender = '1')) as female;

-- Определить кто больше поставил лайков (всего) - мужчины или женщины? (ВАРИАНТ 3)

select 	case (gender)
	when '0' then 'мужчина'
	when '1' then 'женщина'
	end as gender, count(*) from meta_likes inner join profiles on meta_likes.profile_id = profiles.id group by gender order by count(*) desc limit 1;

;

-- Пусть задан некоторый пользователь.
-- Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.

-- В расчет берётся сумма отправленных и принятых сообщений, поэтому запрос состоит из двух частей.

select count(profile_id), profile_id
FROM (
    select from_profile_id as profile_id
    from messages
    where from_profile_id in (
        select initiator_profile_id from friend_requests where target_profile_id = '2' and status = 'approved'
        union
        select target_profile_id from friend_requests where initiator_profile_id = '2' and status = 'approved')
    and to_profile_id = 2

    union all

    select to_profile_id as profile_id
    from messages
    where to_profile_id in (
        select initiator_profile_id from friend_requests where target_profile_id = '2' and status = 'approved'
        union
        select target_profile_id from friend_requests where initiator_profile_id = '2' and status = 'approved')
    and from_profile_id = 2) as uniq

group by profile_id
order by count(profile_id) desc
limit 1;

-- Подсчитать общее количество лайков, которые поставили 10 самых молодых пользователей. (ПОСТАВИЛИ!)
select count(*)
from meta_likes where profile_id in (SELECT id from (select *
from profiles order by birthday desc limit 10) as t);

-- Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей. (ВАРИАНТ 1)

select SUM(`count`) as total from
(select count(*) as `count` from posts_likes where post_id in (
select id from posts where profile_id in (select id from (
        select * from profiles order by birthday desc limit 10)
    as a))
union all
select count(*) from media_files_likes where media_file_id in (
select id from media_files where profile_id in (select id from (
        select * from profiles order by birthday desc limit 10)
    as b))
union all
select count(*) from profiles_likes where profile_id in (
select id from profiles where id in (select id from (
        select * from profiles order by birthday desc limit 10)
    as c))) as t;

-- Подсчитать общее количество лайков к постам, которые получили 10 самых молодых пользователей.

select count(*) as `Likes count` from (select id from posts where profile_id in (select id from (
        select * from profiles order by birthday desc limit 10)
    as t)) as l join posts_likes on l.id=posts_likes.post_id;

-- Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.

-- Алгоритм работы простой - в одну большую метутаблицу заносится информация о действиях пользователя - количество
-- отправленных запросов в друзья, количество групп, в которых состоит пользователь,  количество сообщений,
-- количество медиа, количество лайков. После этого баллы активности группируются по user_id  и выбирается десять самых
-- активных/пассивных пользователей.
-- При этом у каждой активности свой балл, чтобы вес условного запроса в друзья не был равен весу простого лайка.

select profile_id, name, score from (
select profile_id, sum(score) as score from
    (select initiator_profile_id as profile_id,  '10' as score from friend_requests
    union all
    select profile_id, '15' from users_communities
    union all
    select from_profile_id, '3' from messages
    union all
    select profile_id, '5' from media_files
    union all
    select profile_id, '1' from profiles_likes
    union all
    select profile_id, '1' from posts_likes
    union all
    select profile_id, '1' from media_files_likes) as l
group by profile_id order by sum(score) limit 10) as p join profiles on p.profile_id=profiles.id;