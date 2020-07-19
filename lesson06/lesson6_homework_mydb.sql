use social_network;

-- Определить кто больше поставил лайков (всего) - мужчины или женщины? (ВАРИАНТ 1)

SELECT COUNT(*)            AS total
     , SUM(CASE
               WHEN id in
                    (select profile_id from (
                                    select * from posts_likes
                                    union all
                                    select * from profiles_likes
                                    union all
                                    select * from media_files_likes
                                        ) as t where user_id in (select id from profiles where gender like '0')) THEN 1
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
	when '0' then 'мужчина'
	when '1' then 'женщина'
	end as gender, count(*) from profiles_likes left join profiles on profiles_likes.profile_id = profiles.user_id group by gender;

INSERT INTO profiles_likes (profile_id, target_profile_id) VALUES (1, 2);

drop table profiles_likes;
DROP TABLE IF EXISTS `profiles_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `profiles_likes` (
  `profile_id` bigint unsigned NOT NULL,
  `target_profile_id` bigint unsigned NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`profile_id`,`target_profile_id`),
  KEY `target_profile_id` (`target_profile_id`),
  CONSTRAINT `profiles_likes_ibfk_1` FOREIGN KEY (`profile_id`) REFERENCES `profiles` (`id`),
  CONSTRAINT `profiles_likes_ibfk_2` FOREIGN KEY (`target_profile_id`) REFERENCES `profiles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;