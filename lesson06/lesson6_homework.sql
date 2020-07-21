use vk;

-- Определить кто больше поставил лайков (всего) - мужчины или женщины? (ВАРИАНТ 1)

SELECT COUNT(*)            AS total
     , SUM(CASE
               WHEN likes.id in
                    (select id from media where user_id in (select user_id from profiles where gender like 'm')) THEN 1
               ELSE 0 END) AS male
     , SUM(CASE
               WHEN likes.id in
                    (select id from media where user_id in (select user_id from profiles where gender like 'f')) THEN 1
               ELSE 0 END) AS female
FROM likes;

-- Определить кто больше поставил лайков (всего) - мужчины или женщины? (ВАРИАНТ 2)

select (select count(*) from likes) as total,
(select count(*) from likes where user_id in (select user_id from profiles where gender = 'm')) as male,
(select count(*) from likes where user_id in (select user_id from profiles where gender = 'f')) as female;

-- Определить кто больше поставил лайков (всего) - мужчины или женщины? (ВАРИАНТ 3)

select 	case (gender)
	when 'm' then 'мужчина'
	when 'f' then 'женщина'
	end as gender, count(*) from likes left join profiles on likes.user_id = profiles.user_id group by gender;

-- Пусть задан некоторый пользователь.
-- Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.

-- В расчет берётся сумма отправленных и принятых сообщений, поэтому запрос состоит из двух частей.

select count(user_id), user_id
FROM (
    select from_user_id as user_id
    from messages
    where from_user_id in (
        select initiator_user_id from friend_requests where target_user_id = '1' and status = 'approved'
        union
        select target_user_id from friend_requests where initiator_user_id = '1' and status = 'approved')
    and to_user_id = 1

    union all

    select to_user_id as user_id
    from messages
    where to_user_id in (
        select initiator_user_id from friend_requests where target_user_id = '1' and status = 'approved'
        union
        select target_user_id from friend_requests where initiator_user_id = '1' and status = 'approved')
    and from_user_id = 1) as uniq

group by user_id
order by count(user_id) desc
limit 1;


-- Подсчитать общее количество лайков, которые поставили 10 самых молодых пользователей. (ПОСТАВИЛИ!)
select count(*)
from likes where user_id in (SELECT user_id from (select *
from profiles order by birthday desc limit 10) as t);

-- Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей. (ВАРИАНТ 1)
select count(*) from (select * from likes where media_id in (select id from media where user_id in (
    select user_id from (
        select * from profiles order by birthday desc limit 10)
    as t))) as total;

-- Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей. (ВАРИАНТ 2)

select count(*) from (select id from media where user_id in (select user_id from (
        select * from profiles order by birthday desc limit 10)
    as t)) as l left join likes on l.id=likes.media_id
    where likes.id is not null;


-- Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.

-- Алгоритм работы простой - в одну большую метутаблицу заносится информация о действиях пользователя - количество
-- отправленных запросов в друзья, количество групп, в которых состоит пользователь,  количество сообщений,
-- количество медиа, количество лайков. После этого баллы активности группируются по user_id  и выбирается десять самых
-- активных/пассивных пользователей.
-- При этом у каждой активности свой балл, чтобы вес условного запроса в друзья не был равен весу простого лайка.

select user_id, sum(score) as score from
    (select initiator_user_id as user_id,  '10' as score from friend_requests
    union all
    select user_id, '15' from users_communities
    union all
    select from_user_id, '3' from messages
    union all
    select user_id, '5' from media
    union all
    select user_id, '1' from likes) as l
group by user_id order by sum(score) limit 10;